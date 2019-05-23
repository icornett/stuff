# Define Terraform Variable Types https://www.terraform.io/docs/configuration-0-11/variables.html
enum TerraformVarType {
  list
  map
  string
  boolean
  int
}

# https://www.terraform.io/docs/configuration-0-11/variables.html Define Variable Shape
class TerraformVariable {
  [String]$type
  [String]$description
    
  TerraformVariable([String]$description, [String]$type) 
  {
    $this.description = $description
    $this.type = $type
  }
}