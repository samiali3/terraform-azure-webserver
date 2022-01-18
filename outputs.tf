output "private_ssh_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.example.ip_address
}

output "public_url" {
  value = "http://${azurerm_public_ip.example.ip_address}"
}


