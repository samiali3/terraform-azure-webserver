packer {
  required_plugins {
    azure = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/azure"
    }
  }
}

source "azure-arm" "ubuntu" {
  use_azure_cli_auth = true

  os_type         = "Linux"
  image_publisher = "canonical"
  image_offer     = "0001-com-ubuntu-server-focal"
  image_sku       = "20_04-lts-gen2"

  vm_size = "Standard_B1ls"

  build_resource_group_name = "strawb-packerdemo"

  managed_image_resource_group_name = "strawb-packerdemo"
  managed_image_name                = "strawbtest-demo-webserver-v0.1.0"

  ssh_username = "ubuntu"

  // TODO: investigate how to share cross-region
  //
  // Might be doable with Shared Image Galleries... but that may not actually be what I want
  // https://github.com/hashicorp/packer-plugin-azure/issues/20
  // At the very least, Shared Image Gallery image versions do not show up in HCP Packer
}

build {
  name = "webserver"

  hcp_packer_registry {
    bucket_name = "azure-webserver"

    description = <<EOT
Dummy webserver for demonstration purposes
    EOT

    bucket_labels = {
      "owner" = "platform-team"
    }

    build_labels = {
      "os"             = "Ubuntu"
      "ubuntu-version" = "Focal 20.04"
      "version"        = "v0.1.0"
    }
  }

  sources = [
    "source.azure-arm.ubuntu",
  ]

  provisioner "file" {
    source      = "index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get -yq update",
      "sudo apt-get -yq install nginx",
      "sudo mv /home/ubuntu/index.html /var/www/html/index.html",
    ]
  }
}
