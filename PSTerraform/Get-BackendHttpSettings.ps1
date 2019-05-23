class ConnectionDraining {
  [bool]$enabled
  [Int]$drain_timeout_sec
    
  ConnectionDraining([bool]$enabled = $true, [Int]$drain_timeout_sec = 300) 
  {
    $this.enabled = $enabled
    $this.drain_timeout_sec = $drain_timeout_sec
  }
}

class BackendHttpSettings {
  # Required
  [String]$cookie_based_affinity = 'Disabled'
  # Required
  [String]$Protocol = 'Https'
  # Required
  [String]$name
  #[String]$path
  # Required
  [Int]$port
  [String]$probe_name
  #Required
  [Int]$request_timeout
  [Certificate[]]$authentication_certificate
  #[ConnectionDraining]$connection_draining
     
  # Default Constructor
  BackendHttpSettings([String]$name, [Int]$port, [String]$probe_name, [Int]$request_timeout) 
  {
    $this.name = $name
    $this.port = $port
    $this.probe_name = $probe_name
    $this.request_timeout = $request_timeout
  }      
  
  BackendHttpSettings([String]$name, [Int]$port, [String]$probe_name, [Int]$request_timeout, [Collections.ArrayList]$AuthCerts) 
  {
    $this.name = $name
    $this.port = $port
    $this.probe_name = $probe_name
    $this.request_timeout = $request_timeout
    $this.authentication_certificate = $AuthCerts
  }   
}
  
function Get-BackendHttpSettings 
{
  param
  (
    [Collections.ArrayList]
    [Parameter(Mandatory)]
    $BackendHttpConfigs,
    
    [String]
    [Parameter(Mandatory)]
    $namePrefix
  )
    
  [Collections.ArrayList]$backendSettings = @()
  $BackendHttpConfigs.ForEach( {
      Write-Debug -Message "Creating Backend Http Configuration for $($_.Name) with certificates:`t$($_.CertName)"
      [Collections.ArrayList]$certList = @()
      $_.CertName.ForEach( {
          $private:cert = [Certificate]::new($_)
          $null = $certList.Add($private:cert)
      })
      $setting = [BackendHttpSettings]::new("$namePrefix-$($_.Name)-be-htst", $_.Port, $_.ProbeName, $_.RequestTimeout, $certList) | Remove-NullProperties
      $null = $backendSettings.Add($setting) 
      Remove-Variable -Name certList
  })

  return $backendSettings
}
