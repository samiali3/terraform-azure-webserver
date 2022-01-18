terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.resource_group_tags
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "strawb-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = var.vnet_address_space
}



#
# SSH Key
#

resource "tls_private_key" "example" {
  algorithm = "RSA"
}



#
# Example from https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
#

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "example" {
  name                = "strawbtest-public-ip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.example.id
  }
}

locals {
  custom_data = <<CUSTOM_DATA
#!/bin/sh
apt-get -y install nginx
CUSTOM_DATA
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.machine_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.example.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.virtual_machine_source.publisher
    offer     = var.virtual_machine_source.offer
    sku       = var.virtual_machine_source.sku
    version   = var.virtual_machine_source.version
  }

  custom_data = base64encode(local.custom_data)
}

# TODO: Security groups to grant access to VM


# TODO: Load Balancer for web traffic?
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb
