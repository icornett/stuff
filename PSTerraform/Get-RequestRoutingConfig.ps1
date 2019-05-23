function Get-RequestRoutingConfig 
{
  <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Get-RequestRoutingConfig
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Get-RequestRoutingConfig
      another example
      can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
    [Collections.ArrayList]
    $RequestRoutingConfig,
    
    [String]
    [Parameter(Mandatory)]
    $namePrefix
  )
  
  [Collections.ArrayList]$rules = @()
  $RequestRoutingConfig.ForEach( {
      Write-Debug -Message "Creating Request Routing Rule with config:`nName:`t$namePrefix-$($_.Name)-rqrt`nHTTP Listener:`t$($_.HttpListenerName)`nBE Pool Name:`t$($_.BackendAddressPoolName)`nBE HTTP Settings:`t$($_.BackendHttpSettingsName)"
      $private:newRule = [RequestRoutingRule]::new("$namePrefix-$($_.Name)-rqrt", $_.HttpListenerName, $_.BackendAddressPoolName, $_.BackendHttpSettingsName) | Remove-NullProperties
      Write-Debug -Message "Adding rule to list with current length:`t$($rules.Count)"
      $null = $rules.Add($private:newRule)
  })

  return $rules
}
