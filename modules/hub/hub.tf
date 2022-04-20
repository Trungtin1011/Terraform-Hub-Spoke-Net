
//=================== Hub Networking ===================
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${var.hub-name}-network"
  address_space       = [var.hub-address-space]
  location            = var.location
  resource_group_name = var.rg_name

  environment = var.environment
}

resource "azurerm_subnet" "hub-subnet" {
  name                 = "${var.hub-name}-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = [var.hub-address-prefixes]
}


//======================= Hub VM =======================
resource "azurerm_network_interface" "hub-vm-nic" {
  name                = "${var.hub-name}-nic"
  location            = var.location
  resource_group_name = var.rg_name
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.hub-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "hub-vm" {
  name                  = "${var.hub-name}-vm"
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.hub-vm-nic.id]
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
