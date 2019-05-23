class RequestRoutingRule {
  [String]$rule_type = 'Basic'
  [String]$name
  [String]$http_listener_name
  [String]$backend_address_pool_name
  [String]$backend_http_settings_name

  RequestRoutingRule([String]$name, [String]$http_listener_name, [String]$backend_address_pool_name, [String]$backend_http_settings_name) 
  {
    $this.name = $name
    $this.http_listener_name = $http_listener_name
    $this.backend_address_pool_name = $backend_address_pool_name
    $this.backend_http_settings_name = $backend_http_settings_name
  }
}