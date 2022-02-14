resource "azurerm_network_interface" "interface_freedom_private" {
  name                = "interface_freedom_private"
  location            = azurerm_resource_group.rg_1.location
  resource_group_name = azurerm_resource_group.rg_1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet._10-0-2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "association_private" {
  network_interface_id      = azurerm_network_interface.interface_freedom_private.id
  network_security_group_id = azurerm_network_security_group.freedom_nsg.id
}

resource "azurerm_linux_virtual_machine" "freedom_linux_machine_private" {
  name                = "freedom-linux-machine-private"
  resource_group_name = azurerm_resource_group.rg_1.name
  location            = azurerm_resource_group.rg_1.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.interface_freedom_private.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" 
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}