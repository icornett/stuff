class FrontendIPConfiguration {
    [String]$name
    [String]$subnet_id
    [String]$public_ip_address_id

    FrontendIPConfiguration([String]$name, [String]$subnet_id, [String]$public_ip_address_id) 
{
        $this.name = $name
        $this.subnet_id = $subnet_id
        $this.public_ip_address_id = $public_ip_address_id
    }
}