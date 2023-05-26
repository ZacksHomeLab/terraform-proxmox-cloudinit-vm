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
    DHCP = true
    #IPv4Address = "192.168.2.200/24"
    #IPv4Gateway = "192.168.2.1"
    #DHCP6 = false
    #IPv6Gateway = ""
    #IPv6Address = ""
  }

  ### CLOUDINIT SETTINGS
  #username     = "my_username"
  #password     = "my_password"
  #searchdomain = "yourdomain.com"
  #nameservers  = "192.168.2.15 192.168.2.16"

  #sshkeys = <<EOF
  #  ssh-rsa AAAAB3Nzak5qOoe5Zc5ZuLPTIXxYJpub5kQhBNXoSXQ== zackshomelab\zack@ZHLDT01
  #  EOF
}
