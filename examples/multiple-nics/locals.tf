locals {

  /*
    Network Card 1 (net0): DHCP

    Network Card 2 (net1): Static IP

    Network Card 3 (net2): Static IP, different bridge adapter, and using a tagged VLAN.
  */
  networks = [
    {
      dhcp   = true
      bridge = "vmbr0"
    },
    {
      ip      = "192.168.1.2/24"
      gateway = "192.168.1.1"
      bridge  = "vmbr0"
    },
    {
      ip       = "192.168.4.3/24"
      gateway  = "192.168.4.1"
      bridge   = "vmbr1"
      vlan_tag = 4
    }
  ]
}
