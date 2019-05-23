
<#

    Author: Ian Cornett (Attunix) <icorn@allstate.com> <icornett@redapt.com>
    Version:
    Version History:

    Purpose: Support Classes for certificate types

#>

class Certificate {
  [String]$name
     
  Certificate([String]$name) 
  {
    $this.name = $name
  }
}
  
class AuthenticationCertificate : Certificate {
  [String]$data
  
  AuthenticationCertificate([String]$data) : base($name) 
  {
    $this.data = $data
  }
}
  
class SSLCertificate : Certificate {
  [String]$name
  [String]$data
  [String]$password
      
  SSLCertificate([String]$data, [String]$password) : base($name) 
  {
    $this.data = $data
    $this.password = $password
  }
}