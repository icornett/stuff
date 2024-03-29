﻿#requires -Version 5.0
function New-ApplicationGateway {
    <#
      .SYNOPSIS
      Create Dynamic Terraform for AzureRM Application Gateway from doc: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html
      .DESCRIPTION
      This function generates the Terraform code required to create an Azure Application Gateway with WAF.  It is dynamically scalable to allow for provisioning one or more
      instances of SSL Certificates, HTTP Listeners, Backend Address Pools, etc.  It is fully scalable and based on the static Terraform code provided by Stephen Goddard and
      extended to provide the missing dynamic terraform functionality.  It spits out a JSON file which can be consumed by Terraform natively.
      .EXAMPLE
      New-ApplicationGateway
      -

      explains how to use the command
      can be multiple lines
  #>
    param
    (
        [String]
        [Parameter(HelpMessage = 'The storage account ID is the resource ID for the storage account to which you want to send the logs.')]
        $DiagnosticsStorageAccountId = '${var.diagnostics_storage_account_id}',

        [String]
        [Parameter(Mandatory, HelpMessage = 'Name of the region to create the application gateway instance within.')]
        $Location,

        [String]
        [Parameter(Mandatory, HelpMessage = 'The short name of the location, generated by Jenkins location_short_name variable')]
        $LocationShortName,
    
        [String]
        $GatewayName = '${var.gateway_name}',

        # Enable HTTP2 on the application gateway resource.
        [String]
        $Http2Enabled = '${var.http2_enabled}',

        [String]
        $PublicIPAddressId = '${var.public_ip_address_id}',

        [String]
        $ResourceGroup = '${var.resource_group_name}',

        [String]
        [Parameter(Mandatory, HelpMessage = 'Number of the application gateway instances to deploy.')]
        $SkuCapacity,

        [SkuName]
        [Parameter(Mandatory, HelpMessage = 'Name of the application gateway instance to create.')]
        $SkuName,

        [SkuTier]
        [Parameter(Mandatory, HelpMessage = 'Name of the application gateway instance to create.')]
        $SkuTier,

        [String]
        [Parameter(Mandatory, HelpMessage = 'Azure subscription short name/alias')]
        $SubscriptionShortName,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A list of one or more Backend Http Settings blocks')]
        $BackendHttpSettings,

        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A list of one or more Backend Address Pools')]
        $BackendAddressPool,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A list of one or more Frontend IP Configurations')]
        $FrontendIpConfiguration,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A list of one or more Frontend Ports')]
        $FrontendPort,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A collection of one or more Gateway IP configurations')]
        $GatewayIpConfiguration,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A list of one or more Http Listener blocks')]
        $HttpListener,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'One or more request_routing_rule blocks')]
        $RequestRoutingRule,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A collection of one or more probe blocks')]
        $Probe,
    
        [Collections.ArrayList]
        [Parameter(Mandatory, HelpMessage = 'A collection of one or more SSL certificate blocks')]
        $SSLCertificates,
    
        [Hashtable]
        $Tags = @{
            tags = '${merge(map("DOB", "${data.null_data_source.creation_timestamp.outputs["timestamp"]}"), var.tags)}'
        },

        # Is the Web Application Firewall to be enabled
        [String]
        $WafEnabled = '${var.waf_enabled}',

        # The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB. Defaults to 100MB.
        [String]
        $WafFileUploadLimitMb = '${var.waf_file_upload_limit_mb}',

        # The Web Application Firewall Mode. Possible values are Detection and Prevention.
        [String]
        $WafFirewallMode = '${var.waf_firewall_mode}',

        # The maximum request body size field is specified in KBs and controls overall request size limit excluding any file uploads.
        [String]
        $WafMaxRequestBodySizeKb = '${var.waf_max_request_body_size_kb}',

        # Web Application Firewall allows you to configure request size limits within lower and upper bounds,
        [String]
        $WafRequestBodyCheck = '${var.waf_request_body_check}',

        # The Type of the Rule Set used for this Web Application Firewall.
        [String]
        $WafRuleSetType = '${var.waf_rule_set_type}',

        # The Version of the Rule Set used for this Web Application Firewall.
        [String]
        $WafRuleSetVersion = '${var.waf_rule_set_version}'
    )
    <#
      "$null =" 'values' are used to swallow up extra zeroes that are left when adding elements to ArrayLists.  They tend to exclaim their index
      values and can be somewhat less than predictable.   As such, the additions may be redundantly silenced.
  #>
    [String]$namePrefix = "$SubscriptionShortName-$LocationShortName-$GatewayName"

    # App Gateway Static Properties
    $AppGateway = [PSCustomObject]@{
        name                   = "$namePrefix-waf"
        resource_group_name    = $ResourceGroup
        location               = $Location
        disabled_ssl_protocols = @('TLSv1_0', 'TLSv1_1')
        enable_http2           = $Http2Enabled
    } 

    # Add Sku Block
    $Sku = @([Sku]::new($SkuName, $SkuTier, $SkuCapacity))
    $AppGateway | Add-Member -NotePropertyName 'sku' -NotePropertyValue $Sku

    [Collections.ArrayList]$gwConfig = @()
    $null = $gwConfig.Add($(Get-GatewayIpConfigurations -GatewayConfigs $GatewayIpConfiguration -namePrefix $namePrefix))
    $AppGateway | Add-Member -NotePropertyName 'gateway_ip_configuration' -NotePropertyValue $gwConfig -PassThru

    [Collections.ArrayList]$fePorts = @()
    $null = $fePorts.Add($(Get-FrontendPortConfigs -FrontendPort $FrontendPort -namePrefix $namePrefix))
    $AppGateway | Add-Member -NotePropertyName 'frontend_port' -NotePropertyValue $fePorts -PassThru

    [Collections.ArrayList]$feConfigs = @()
    $null = $feConfigs.Add($(Get-FrontendIpConfigs -FrontendIpConfigs $FrontendIpConfiguration -namePrefix $namePrefix))
    $AppGateway | Add-Member  -NotePropertyName 'frontend_ip_configuration' -NotePropertyValue $feConfigs -PassThru

    [Collections.ArrayList]$backendPools = @()
    $null = $backendPools.Add($(Get-BackendAddressPools -BackendAddressConfig $BackendAddressPool -namePrefix $namePrefix -Debug))
    $AppGateway | Add-Member -NotePropertyName 'backend_address_pool' -NotePropertyValue $backendPools -PassThru

    [Collections.ArrayList]$backendSettings = @()
    $null = $backendSettings.Add($(Get-BackendHttpSettings -BackendHttpConfigs $BackendHttpSettings -namePrefix $namePrefix))
    $AppGateway | Add-Member -NotePropertyName 'backend_http_settings' -NotePropertyValue $backendSettings -PassThru

    [Collections.ArrayList]$listeners = @()
    $null = $listeners.Add($(Get-HttpListeners -HttpListener $HttpListener -namePrefix $namePrefix))
    $AppGateway | Add-Member -NotePropertyName 'http_listener' -NotePropertyValue $listeners -PassThru

    #  Create SSL Certificate Array, create password variable, and set environment variable to that value for Terraform run.
    [Collections.ArrayList]$certs = @()
    $null = $certs.Add($(Get-SSLCertificateConfig -SSLCertificates $SSLCertificates -namePrefix $namePrefix))
    $AppGateway | Add-Member -NotePropertyName 'ssl_certificates' -NotePropertyValue $certs -PassThru

    # Create Request Routing Rules
    [Collections.ArrayList]$rules = @()
    $null = $rules.Add($(Get-RequestRoutingConfig -RequestRoutingConfig $RequestRoutingRule -namePrefix $namePrefix))
    $AppGateway | Add-Member -NotePropertyName 'request_routing_rule' -NotePropertyValue $rules -PassThru

    [Collections.ArrayList]$probeList = @()
    $null = $probeList.Add($(Get-HealthProbes -ProbeConfigs $Probe -namePrefix $namePrefix))
    $AppGateway | Add-Member -NotePropertyName 'probe' -NotePropertyValue $probeList -PassThru

    $WafConfiguration = [PSCustomObject]@{
        enabled                  = $WafEnabled
        firewall_mode            = $WafFirewallMode
        rule_set_type            = $WafRuleSetType
        rule_set_version         = $WafRuleSetVersion
        max_request_body_size_kb = $WafMaxRequestBodySizeKb
        request_body_check       = $WafRequestBodyCheck
        file_upload_limit_mb     = $WafFileUploadLimitMb
    }

    $AppGateway | Add-Member -NotePropertyName 'waf_configuration' -NotePropertyValue $WafConfiguration -PassThru

    $AppGateway | Add-Member -NotePropertyName 'tags' -NotePropertyValue $Tags -PassThru # Interpolated Terraform for output
    $lifecycle = [PSCustomObject]@{
        ignore_changes        = @('tags.DOB')
        create_before_destroy = $true
    }
    $AppGateway | Add-Member -NotePropertyName 'lifecycle' -NotePropertyValue $lifecycle -PassThru
    $Provisioner = [PSCustomObject]@{
        command     = '${path.module}/scripts/enableAppGatewayLogging.sh'  
        environment = @{
            diagnostic_name    = '${azurerm_application_gateway.app_gw.name}-diagnostics'
            storage_account_id = '${var.diagnostics_storage_account_id}'
            resource_id        = '${azurerm_application_gateway.app_gw.id}'
        }
    }
    $AppGateway | Add-Member  -NotePropertyName 'provisioner' -NotePropertyValue $Provisioner -PassThru

    # Assign name of terraform object node
    $GwName = [PSCustomObject]@{
        app_gw = @($AppGateway)
    }

    # Add AzureRm resource type
    $AzRmAppGw = [PSCustomObject]@{
        azurerm_application_gateway = @($GwName)
    }

    # Roll everything up under resource
    $resource = [PSCustomObject]@{
        resource = @($AzRmAppGw)
    }

    return $resource
}
