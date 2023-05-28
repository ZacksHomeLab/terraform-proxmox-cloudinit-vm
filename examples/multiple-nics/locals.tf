locals {

  # What node should the VM be deployed to?
  target_node = "pve1"

  # What's the name of the Virtual Machine template that will be used to create a clone of?
  template = "ubuntu-2204"

  # Virtual Machine Storage Location
  storage_location = "local-pve"

  # Network Adapter net0 IP Configuration
  network_adapter_1 = {
    dhcp = true
  }

  # Network Adapter net1 IP Configuration
  network_adapter_2 = {
    # By default, DHCP is set to False if it isn't provided
    ip      = "192.168.1.2/24"
    gateway = "192.168.1.1"
  }

  # Network Adapter net2 IP Configuration
  network_adapter_3 = {
    # By default, DHCP is set to False if it isn't provided
    ip      = "192.168.1.3/24"
    gateway = "192.168.1.1"
  }

  # Default network adapter model & bridge for net0, net1, and net2
  network_model  = "virtio"
  network_bridge = "vmbr0"
}
