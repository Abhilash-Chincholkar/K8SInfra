output "subnet_ids" {
  value = {
    for vnet_key, vnet in azurerm_virtual_network.virtual_network :
    vnet_key => {
      for sn in vnet.subnet :
      sn.name => sn.id
    }
  }
}
