#requires -Version 5.0
class BackendAddressPool {
  [String]$name
  [Collections.Generic.List[String]]$fqdns
  [Collections.Generic.List[String]]$ip_addresses
  [Switch]$UseIpAddress
   
  BackendAddressPool([String]$name) 
  {
    $this.name = $name
    $this.fqdns = @()
  }
   
  BackendAddressPool([String]$name, [Collections.ArrayList]$fqdns) 
  {
    $this.name = $name
    $this.fqdns = $fqdns
  }

  BackendAddressPool([String]$name, [Collections.ArrayList]$ip_addresses, [Switch]$UseIpAddress) 
  {
    $this.name = $name
    $this.$ip_addresses = $ip_addresses
    $this.$UseIpAddress = $UseIpAddress
  }
}
