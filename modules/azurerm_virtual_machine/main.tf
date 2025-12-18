resource "azurerm_network_interface" "nic" {
    name                = var.nic_name
    location            = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
      name                          = var.ip_configuration_name
      subnet_id                     = data.azurerm_subnet.subnetid.id
      private_ip_address_allocation = "Dynamic"

    }
  }
  
data "azurerm_subnet" "subnetid" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

  resource "azurerm_network_security_group" "nsg" {
    name                = var.nsg_name
    location            = var.location
    resource_group_name = var.resource_group_name

    security_rule {
      name                       = "myrule"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  
}
 

resource "azurerm_linux_virtual_machine" "brijeshvm" {
  name                = var.vmname
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

 custom_data = base64encode(<<EOF
#!/bin/bash
set -e

# Update packages
apt-get update -y

# Install nginx
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Custom index.html
echo "<h1>Deployed via Terraform by Nilesh</h1>" > /var/www/html/index.html
EOF
)
}

