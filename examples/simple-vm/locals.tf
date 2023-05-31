locals {

  # DHCP is prioritized
  # Set DHCP to false and configure the IPV4 Address and Gateway to set a static IP
  # This module also supports IPv6 address and gateway. You can set IPv6 DHCP to true if you support IPv6
  networks = [
    {
      dhcp = true
      #ip = "192.168.2.200/24"
      #gateway = "192.168.2.1"
      #dhcp6 = false
      #gateway6 = ""
      #ip6 = ""
      bridge = "nat" # May need to adjust this to vmbr0 or whatever adapter you have in Proxmox
    }
  ]
}
