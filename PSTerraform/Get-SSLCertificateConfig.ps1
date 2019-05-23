#requires -Version 4.0
function Get-SSLCertificateConfig 
{
  <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Get-SSLCertificateConfig
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Get-SSLCertificateConfig
      another example
      can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
    [Collections.ArrayList]
    $SSLCertificates, 
    
    [Parameter(Mandatory)]
    [String]
    $namePrefix
  )
  
  [Collections.ArrayList]$certs = @()
  [Collections.ArrayList]$vars = $global:terraformVariables.variable
  Write-Debug -Message "vars count is $($vars.Count)"
  $SSLCertificates.ForEach( {
      Write-Debug -Message "Creating SSL Cert with props:`nName:`t $($_.Name) `n Data:`t $($_.Data) `n Password:`t $($_.Password)"
      $local:tfVariable = @{
        description = "SSL Certificate Password for $($_.Name)"
      }
      Write-Debug -Message "Adding variable for ssl_cert_$($_.Name)_password"
      $null = $vars.Add([PSCustomObject]@{
          "ssl_cert_$($_.Name)_password" = $local:tfVariable
      })
      Write-Debug -Message "Adding environment variable for TF_VAR_ssl_cert_$($_.Name)_password"
      $null = New-Variable -Name "env:TF_VAR_ssl_cert_$($_.Name)_password" -Value $_.Password
      $cert = @{
        name     = $_.Name
        data     = $_.Data
        password = "`${var.ssl_cert_$($_.Name)_password}"
      }
      Write-Debug -Message "Adding Certificate to list with length:`t$($certs.Count)"
      $null = $certs.Add($cert)
  })
  $global:terraformVariables.variable = $vars
  return $certs
}
