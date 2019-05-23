class FrontendPort {
    [String]$name
    [Int]$port
  
    FrontendPort([String]$name, [Int]$port) {
        $this.name = $name
        $this.port = $port
    }
}

function Get-FrontendPortConfigs {
    <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Get-FrontendPortConfigs
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Get-FrontendPortConfigs
      another example
      can have as many examples as you like
  #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Please add a help message here')]
        [Collections.ArrayList]
        $FrontendPort, 
    
        [Parameter(Mandatory, Position = 1, HelpMessage = 'The name prefix to add to the port configs')]
        [String]
        $namePrefix
    )
  
    [Collections.ArrayList]$fePorts = @()
    $FrontendPort.ForEach( {
            Write-Debug -Message "Creating FE Port...  Name:`t$namePrefix-$($_.Name)-feport at port $($_.Port)"
            $private:port = [FrontendPort]::new("$namePrefix-$($_.Name)-feport", $_.Port) | Remove-NullProperties
            $fePorts.Add($port) | Out-Null
        })
  
    return $fePorts
}