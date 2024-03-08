provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "git::git@github.com:slovink/terraform-azure-resource-group.git?ref=1.0.0"

  label_order = ["name", "environment"]
  name        = "rg"
  environment = "examplee"
  location    = "Canada Central"
}


#Vnet
module "vnet" {
  source = "git::git@github.com:slovink/terraform-azure-vnet.git?ref=1.0.0"

  name        = "app"
  environment = "example"
  label_order = ["name", "environment"]

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
  enable_ddos_pp      = false

  #subnet
  #  subnet_names                  = ["subnet1"]
  #  subnet_prefixes               = ["10.0.1.0/24"]
  #  disable_bgp_route_propagation = false
  #
  #
  #  enabled_route_table = false
  #  routes              = [
  #    {
  #      name           = "rt-test"
  #      address_prefix = "0.0.0.0/0"
  #      next_hop_type  = "Internet"
  #    }
  #  ]

}

#Key Vault
module "vault" {
  depends_on = [module.resource_group, module.vnet]
  source     = "./.."

  name        = "user"
  environment = "test"
  label_order = ["name", "environment", ]

  resource_group_name = module.resource_group.resource_group_name

  purge_protection_enabled    = false
  enabled_for_disk_encryption = true

  sku_name = "standard"

  subnet_id          = module.vault.id
  virtual_network_id = module.vnet.id
  #private endpoint
  enable_private_endpoint = true

  #access_policy
  access_policy = [
    {
      object_id = ""
      key_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "UnwrapKey",
        "WrapKey",

      ]
      certificate_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "ManageContacts",
        "ManageIssuers",
        "GetIssuers",
        "ListIssuers",
        "SetIssuers",
        "DeleteIssuers"
      ]
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore"
      ]
      storage_permissions = []

    }
  ]
}

