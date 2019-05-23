class Probe {
  [String]$protocol = 'Https'
  [Int]$interval
  [String]$name
  [String]$path
  [Int]$timeout
  [Int]$unhealthy_threshold
    
  Probe ([String]$name, [String]$Path, [Int]$Interval, [Int]$Timeout, [Int]$UnhealthyThreshold) 
  {
    $this.name = $name
    $this.interval = $Interval
    $this.path = $Path
    $this.timeout = $Timeout
    $this.unhealthy_threshold = $UnhealthyThreshold
  }
}