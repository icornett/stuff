enum SkuName {
  Standard_v2
  WAF_v2
}
  
enum SkuTier {
  Standard_v2
  WAF_v2
}
  
class Sku {
  [String]$name
  [String]$tier
  [Int]$capacity
    
  Sku([Skuname]$name = [SkuName]::WAF_v2, [SkuTier]$tier = [SkuTier]::WAF_v2, [Int]$Capacity = 1) 
  {
    $this.name = $name
    $this.tier = $tier
    $this.capacity = $Capacity
  }
}