data "azurerm_virtual_network" "hub-vnet" {
    name = var.hub-name
    resource_group_name = var.rg_name
}

resource "azurerm_virtual_network" "spoke-vnet" {
  name                = "${var.spoke-name}-network"
  address_space       = [var.spoke-address-space]
  location            = var.location
  resource_group_name = var.rg_name

  environment = var.environment
}

resource "azurerm_subnet" "spoke-subnet" {
  name                 = "${var.spoke-name}-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = [var.spoke-address-prefixes]
}

resource "azurerm_virtual_network_peering" "spoke-hub-peer" {
  name                      = "spoke-to-hub-peer"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.spoke-vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_virtual_network_peering" "hub-spoke-peer" {
  name                      = "hub-to-spoke-peer"
  resource_group_name       = data.azurerm_virtual_network.hub-vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke-vnet.id
}