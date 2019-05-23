#requires -Version 4.0
function Get-FrontendIpConfigs 
{
    <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Get-FrontendIpConfigs
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Get-FrontendIpConfigs
      another example
      can have as many examples as you like
  #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
        [Collections.ArrayList]
        $FrontendIpConfigs,

        [Parameter(Mandatory)]
        [String]
        $namePrefix
    )
  
    [Collections.ArrayList]$feConfigs = @()
    $FrontendIpConfigs.ForEach( {
            Write-Debug -Message "Creating Frontend IP Configuration for $($_.Name) on Subnet ID:`t$($_.SubnetId)`n With Public IP ID $($_.PublicIPAddressId)"
            $config = [FrontendIPConfiguration]::new("$namePrefix-$($_.Name)-feip", $_.SubnetId, $_.PublicIPAddressId) | Remove-NullProperties
            Write-Debug -Message "Adding FE IP Config to list with length $($feConfigs.Count)"
            $null = $feConfigs.Add($config)
        })
  
    return $feConfigs  
}
