class GatewayIPConfiguration {
  [String]$name
  [String]$subnet_id
  
  GatewayIPConfiguration([String]$name, [String]$subnet_id) 
  {
    $this.name = $name
    $this.subnet_id = $subnet_id
  }
}

function Get-GatewayIpConfigurations 
{
  <#
      .SYNOPSIS
      Get-GatewayIpConfigurations creates a list of Gateway IP Address Configurations for the 
      Terraform AzureRM Application Gateway.

      .DESCRIPTION
      This function takes a list of Name and SubnetId tuple values, and outputs them as Gateway IP 
      Address Configurations for Terraform Azure Resource Manager Application Gateway per the 
      definition in the Terraform docs below

      .EXAMPLE
      Get-GatewayIpConfigurations -GatewayConfigs <A list of GW Hashtables> `
      -namePrefix <The name to prepend to any resource i.e. "aflern-eus2-<<name of gateway>>">

      .NOTES
      Place additional notes here.

      .LINK
      https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#gateway_ip_configuration


      .INPUTS
      GatewayConfigs - A list of Hashtables containing a Name and SubnetId property
      namePrefix - A string <The name to prepend to any resource i.e. "aflern-eus2-<<name of gateway>>">

      .OUTPUTS
      A List of Gateway IP Configuration objects
  #>
  
  param
  (
    [Collections.ArrayList]
    [Parameter(Mandatory)]
    $GatewayConfigs, 
    
    [String]
    [Parameter(Mandatory)]
    $namePrefix
  )
  

  [Collections.ArrayList]$config = @()
  $GatewayConfigs.ForEach( {
      Write-Debug -Message "Creating Gateway IP Configuration named:`t$namePrefix-$($_.Name)-gwip`n at Subnet Id:`t$($_.SubnetId)" 
      $cfg = [GatewayIPConfiguration]::new("$namePrefix-$($_.Name)-gwip", $_.SubnetId) | Remove-NullProperties
      Write-Debug -Message "Gateway IP Configuration Created...  Adding to array with current length:`t$($config.Count)"
      $null = $config.Add($cfg)
      Write-Debug -Message 'Gateway Configuration added to ArrayList'
  })
  
  Write-Debug -Message 'Returning ArrayList with GatewayIPConfiguration object(s)'
  return $config
}
