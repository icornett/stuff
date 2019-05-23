function Get-HealthProbes 
{
  <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Get-HealthProbes
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Get-HealthProbes
      another example
      can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
    [Collections.ArrayList]
    $ProbeConfigs,
    
    [String]
    [Parameter(Mandatory)]
    $namePrefix
  )
  
  [Collections.ArrayList]$probeList = @()
  $ProbeConfigs.ForEach( {
      Write-Debug -Message "Creating new probe named:`t$namePrefix-$($_.Name)-probe `nProbe Path:`t $($_.Path)`nPolling Interval:`t$($_.Interval)`nTimeout:`t$($_.Timeout)`nUnhealthy Threshold:`t$($_.UnhealthyThreshold)"
      $new_probe = [Probe]::new("$namePrefix-$($_.Name)-probe", $_.Path, $_.Interval, $_.Timeout, $_.UnhealthyThreshold) | Remove-NullProperties
      Write-Debug -Message 'Probe created!  Adding to array...'
      $null = $probeList.Add($new_probe)
  })

  return $probeList
}
