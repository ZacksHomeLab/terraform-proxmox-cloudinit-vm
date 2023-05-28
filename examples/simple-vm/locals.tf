locals {

  # What node should the VM be deployed to?
  target_node = "pve1"

  # What's the name of the Virtual Machine template that will be used to create a clone of?
  template = "ubuntu-2204"

  # Virtual Machine Storage Location
  storage_location = "local-pve"


  # DHCP is prioritized
  # Set DHCP to false and configure the IPV4 Address and Gateway to set a static IP
  # This module also supports IPv6 address and gateway. You can set IPv6 DHCP to true if you support IPv6
  network_config = {
    dhcp = true
    #ip = "192.168.2.200/24"
    #gateway = "192.168.2.1"
    #dhcp6 = false
    #gateway6 = ""
    #ip6 = ""
  }
}
