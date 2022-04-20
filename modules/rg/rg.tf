resource "azurerm_resource_group" "rg" {
    name     = var.rg-name
    location = var.service-location
    tags     = var.tags
}