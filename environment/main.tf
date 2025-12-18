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

module "vm1" {
  depends_on = [ module.subnet, module.pip ]
  source = "../modules/azurerm_virtual_machine"
  nic_name = "nic_brijesh_28"
  location = "westus"
  resource_group_name = "rg_brijesh_28"
  nsg_name = "nsg_brijesh_28"
  admin_password = "Brijesh@1234"
  admin_username = "brijeshuser"
  vmname = "vm-1"
  image_publisher = "Canonical"
  image_offer = "UbuntuServer"
  image_sku = "18.04-LTS"
  image_version = "latest"
  ip_configuration_name = "ipconfig_brijesh_28_1"
  subnet_name = "subnet_brijesh_28"
  vnet_name = "vnet_brijesh_28"
   
}

module "vm2" {
  depends_on = [ module.subnet, module.pip ]
  source = "../modules/azurerm_virtual_machine"
  nic_name = "nic_brijesh_28_2"
  location = "westus"
  resource_group_name = "rg_brijesh_28"
  nsg_name = "nsg_brijesh_28"
  admin_password = "Brijesh@1234"
  admin_username = "brijeshuser1"
  vmname = "vm-2"
  image_publisher = "Canonical"
  image_offer = "UbuntuServer"
  image_sku = "18.04-LTS"
  image_version = "latest"
  ip_configuration_name = "ipconfig_brijesh_28_1"
  subnet_name = "subnet_brijesh_28"
  vnet_name = "vnet_brijesh_28"
   
}

module "lb" {
  depends_on = [ module.rg, module.pip ]
  source = "../modules/azurem_load_balancer"
  lb_name = "lb_brijesh_28"
  location = "westus"
  frontend_ip_configuration_name = "feconfig_brijesh_28"
  backendpool_name = "bepool_brijesh_28"
  probe_name = "healthprobe_brijesh_28"
  lb_rule_name = "lbrule_brijesh_28"
  pip_name = "pip_brijesh_28"
 resource_group_name = "rg_brijesh_28"
  
  
}



module "nic_lb_association_vm1" {
  depends_on = [ module.lb, module.subnet, module.vm1 ]
  source = "../modules/azurerm_nic_lb_association"
  nic_name = "nic_brijesh_28"
  resource_group_name = "rg_brijesh_28"
  lb_name = "lb_brijesh_28"
  lb_pool = "bepool_brijesh_28"
  ip_configuration_name = "ipconfig_brijesh_28_1"
  
} 

module "nic_lb_association_vm2" {
  depends_on = [ module.lb, module.subnet, module.vm2 ]
  source = "../modules/azurerm_nic_lb_association"
  nic_name = "nic_brijesh_28_2"
  resource_group_name = "rg_brijesh_28"
  lb_name = "lb_brijesh_28"
  lb_pool = "bepool_brijesh_28"
  ip_configuration_name = "ipconfig_brijesh_28_1"
  
} 




module "bastion" {
  depends_on = [ module.bastion_subnet, module.pip_bastion ]
  source = "../modules/azurerm_bastion_host"
  
  bastion_name          = "bastion_brijesh_28"
  location              = "westus"
  resource_group_name   = "rg_brijesh_28"
  ip_configuration_name = "bastion_ipconfig_brijesh_28"
  subnet_id             = module.bastion_subnet.subnet_id
  public_ip_id          = module.pip_bastion.public_ip_id
}

module "bastion_subnet" {
  depends_on = [ module.vnet ]
  source = "../modules/azurerm_subnet"
  resource_group_name = "rg_brijesh_28"
  vnet_name = "vnet_brijesh_28"
  subnet_name = "AzureBastionSubnet"
  address_prefixes = ["10.0.2.0/24"]
}

module "pip_bastion" {
  depends_on = [ module.rg ]
  source = "../modules/azurerm_public_ip"
  resource_group_name = "rg_brijesh_28"
  location = "westus"
  pip_name = "pip_bastion_brijesh_28"
}