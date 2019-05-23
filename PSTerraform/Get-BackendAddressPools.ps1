function Get-BackendAddressPools {
  <#
      .SYNOPSIS
      Creates and returns a list of Backend Address Pool objects
      .DESCRIPTION
      Creates and returns a list of custom [BackendAddressPool] objects
      to be referenced in Terraform AzureRM Application Gateway with WAF
      .EXAMPLE
      Get-BackendAddressPools -BackendAddressConfig <list of configurations> -namePrefix <naming prefix for resource>
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
    [Collections.ArrayList]
    $BackendAddressConfig, 
    
    [Parameter(Mandatory, Position = 1)]
    [String]
    $namePrefix
  )
  
  [Collections.ArrayList]$backendPools = @()
  $BackendAddressConfig.ForEach({
      if($_.UseIpAddresses){
        Write-Debug -Message "Creating Backend Address Pool Name:`t$($_.Name) with IP Addresses:`t$($_.IPAddresses)"
        $private:config = [BackendAddressPool]::new("$namePrefix-$($_.Name)-beap", $_.IPAddresses, $_.UseIpAddresses) | Remove-NullProperties
        $private:config.PSObject.Members.remove('UseIpAddress')
      }
      else {
        Write-Debug -Message "Creating Backend Address Pool Name:`t$($_.Name) with FQDNs: $($_.Fqdns)"
        $private:config = [BackendAddressPool]::new("$namePrefix-$($_.Name)-beap", $_.Fqdns) | Remove-NullProperties
      }
      $null = $backendPools.Add($config)
  })
        
  return $backendPools
}
