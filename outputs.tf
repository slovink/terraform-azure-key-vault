output "id" {
  value = join("", azurerm_key_vault.key_vault[*].id)
}

output "vault_uri" {
  value = join("", azurerm_key_vault.key_vault[*].vault_uri)
}

output "virtual_network_id" {
  value = join("", azurerm_private_dns_zone_virtual_network_link.vent-link[*].virtual_network_id)
}
