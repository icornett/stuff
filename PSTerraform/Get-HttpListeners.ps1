function Get-HttpListeners 
{
  <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Get-HttpListeners
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Get-HttpListeners
      another example
      can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
    [Collections.ArrayList]
    $HttpListener,
    
    [Parameter(Mandatory)]
    [String]
    $namePrefix
  )
  
  [Collections.ArrayList]$listeners = @()
  $HttpListener.ForEach( {
      Write-Debug -Message "Creating HTTP Listener with config:`nName:`t$namePrefix-$($_.Name)-httplstn`nFE Config Name:`t$($_.FrontendIPConfiguration)`nPort Name:`t$($_.FrontendPortName)`nSSL Cert Name:`t$($_.SSLCertificateName)"
      $private:listener = [HttpListener]::new("$namePrefix-$($_.Name)-httplstn", $_.FrontendIpConfigurationName, $_.FrontendPortName, $_.SSLCertificateName) | Remove-NullProperties
      Write-Debug -Message "Adding Listener to ArrayList with current length:`t$($listeners.Count)"
      $null = $listeners.add($listener)
  })

  return $listeners
}
