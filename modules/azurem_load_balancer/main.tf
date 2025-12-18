resource "azurerm_lb" "lb" {
    name                = var.lb_name
    location            = var.location
    resource_group_name = var.resource_group_name
    
    frontend_ip_configuration {
        name                 = var.frontend_ip_configuration_name
       public_ip_address_id = data.azurerm_public_ip.pip.id
    }
}

data "azurerm_public_ip" "pip" {
    name                = var.pip_name
    resource_group_name = var.resource_group_name
  
}


 resource "azurerm_lb_backend_address_pool" "bepool" {
    loadbalancer_id     = azurerm_lb.lb.id
    name                = var.backendpool_name
  }

   resource "azurerm_lb_probe" "lbprobe" {
    loadbalancer_id     = azurerm_lb.lb.id
    name                = var.probe_name
    protocol            = "Tcp"
    port                = 80

 }
 
resource "azurerm_lb_rule" "lb_rule" {
    loadbalancer_id                = azurerm_lb.lb.id
    name                           = var.lb_rule_name
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
    probe_id                       = azurerm_lb_probe.lbprobe.id
    
  }
  

     
  
  


