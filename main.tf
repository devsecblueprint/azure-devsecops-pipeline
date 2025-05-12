resource "azurerm_resource_group" "example" {
    name     = "dsb-tfcp-rg"
    location = "East US"
}

resource "azurerm_storage_account" "example" {
    name                     = "dsbtfcpstorage"
    resource_group_name      = azurerm_resource_group.example.name
    location                 = azurerm_resource_group.example.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
    name                  = "dsbtfcpcontainer"
    storage_account_id = azurerm_storage_account.example.id
    container_access_type = "private"
}