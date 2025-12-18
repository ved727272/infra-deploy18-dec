resource "azurerm_public_ip" "pip" {
    name                = var.pip_name
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = "Static"
    sku                 = "Standard"
  }

output "public_ip_id" {
    value = azurerm_public_ip.pip.id
  }

