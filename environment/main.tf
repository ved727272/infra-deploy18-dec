module "rg" {
  source = "../modules/azurerm_resource_group"
  resource_group_name = "rg_brijesh_28"
  location = "westus"
  
}
module "vnet" {
  depends_on = [ module.rg ]
  source = "../modules/azurerm_virtual_network"
  resource_group_name = "rg_brijesh_28"
  location = "westus"
  vnet_name = "vnet_brijesh_28"
  address_space = ["10.0.0.0/16"]
}

module "subnet" {
  depends_on = [ module.vnet ]
  source = "../modules/azurerm_subnet"
  resource_group_name = "rg_brijesh_28"
  vnet_name = "vnet_brijesh_28"
  subnet_name = "subnet_brijesh_28"
  address_prefixes = ["10.0.1.0/24"]
  
}

module "pip" {
  depends_on = [ module.rg ]
  source = "../modules/azurerm_public_ip"
  resource_group_name = "rg_brijesh_28"
  location = "westus"
  pip_name = "pip_brijesh_28"
}

