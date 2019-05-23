#requires -Version 5.0
class HttpListener {
  [String]$name
  [String]$frontend_ip_configuration_name
  [String]$frontend_port_name
  [String]$ssl_certificate_name
  [String]$protocol = 'Https'
  
  HttpListener([String]$name, [String]$frontend_ip_configuration_name, [String]$frontend_port_name, [String]$ssl_certificate_name) 
  {
    $this.name = $name
    $this.frontend_ip_configuration_name = $frontend_ip_configuration_name
    $this.frontend_port_name = $frontend_port_name
    $this.ssl_certificate_name = $ssl_certificate_name
  }
}
