data "azurerm_virtual_network" "hub-vnet" {
    name = var.hub-name
    resource_group_name = var.rg_name
}

//=================== Spokes Networking ====================
resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = "${var.spoke-name}-network-1"

  address_space       = [var.spoke1-address-space]
 //address_space       = ["10.70.216.0/25"]

  location            = var.location
  resource_group_name = var.rg_name

  environment = var.environment
}

resource "azurerm_subnet" "spoke1-subnet" {
  name                 = "${var.spoke-name}-subnet-1"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name

  address_prefixes     = [var.spoke1-address-prefixes]
 //address_prefixes     = "10.70.216.0/25"
}

resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "${var.spoke-name}-network-2"

  address_space       = [var.spoke2-address-space]
  //address_space       = ["10.70.216.128/25"]

  location            = var.locations
  resource_group_name = var.rg_name

  environment = var.environment
}

resource "azurerm_subnet" "spoke2-subnet" {
  name                 = "${var.spoke-name}-subnet-2"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name

  address_prefixes     = [var.spoke2-address-prefixes]
 //address_prefixes     = "10.70.216.128/25"
}


//===================== Vnet Peering ======================
resource "azurerm_virtual_network_peering" "hub-to-spoke1" {
  name                         = "hub-to-spoke1"
  resource_group_name          = data.azurerm_virtual_network.hub-vnet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke1-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false 
}

resource "azurerm_virtual_network_peering" "spoke1-to-hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = var.rg_name
  virtual_network_name         = azurerm_virtual_network.spoke1-vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub-to-spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = data.azurerm_virtual_network.hub-vnet.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke2-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false 
}

resource "azurerm_virtual_network_peering" "spoke2-to-hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = var.rg_name
  virtual_network_name         = azurerm_virtual_network.spoke2-vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}


//======================= Spokes VM =======================
resource "azurerm_network_interface" "spoke1-vm-nic" {
  name                = "${var.spoke-name}-nic-1"
  location            = var.location
  resource_group_name = var.rg_name
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.spoke1-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "spoke1-vm" {
  name                  = "${var.spoke-name}-vm-1"
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.spoke1-vm-nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "spoke2-vm-nic" {
  name                = "${var.spoke-name}-nic-2"
  location            = var.location
  resource_group_name = var.rg_name
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.spoke2-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "spoke2-vm" {
  name                  = "${var.spoke-name}-vm-2"
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.spoke2-vm-nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment
  }
}