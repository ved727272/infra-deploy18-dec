resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_id
  }
}
variable "bastion_name" {
  description = "Name of the Bastion host"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "ip_configuration_name" {
  description = "Name of the IP configuration for Bastion"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Bastion"
  type        = string
}

variable "public_ip_id" {
  description = "Public IP ID for Bastion"
  type        = string
}
