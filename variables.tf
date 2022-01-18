
variable "machine_size" {
  type    = string
  default = "Standard_B1ls"
}

variable "resource_group_tags" {
  default = {
    Terraform = "true"
  }
}

variable "resource_group_name" {
  default = "strawb-demo-webserver"
}

variable "location" {
  default = "UK South"
}

variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  default = ["10.0.2.0/24"]
}

variable "virtual_machine_source" {
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
