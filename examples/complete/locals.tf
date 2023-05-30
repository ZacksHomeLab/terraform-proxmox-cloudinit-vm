locals {

  # Adjust the Virtual Machine's specs here
  memory = 1024
  cores  = 1

  # Cloudinit Settings
  ciuser = "my_username"
  # See the homepage README.md on how to add SSH Keys.
  sshkeys = ""

  /*
    Disk Configurations

    Create 2 Disks
      Disk 1 (virtio0): 
        - Set type to 'virtio' 
        - Set storage_location_1 variable in terraform.tfvars
        - Set size to 10G
      Disk 2 (scsi0):
        - Set type to 'scsi'
        - Set storage_location_2 variable in terraform.tfvars
        - Set size to 25G
        - Enable writethrough cache
  */
  # Set the disk locations in terraform.tfvars
  storage_location_1 = var.storage_location_1
  storage_location_2 = var.storage_location_2

  disks = [
    # This will create disk virtio0
    {
      type    = "virtio"
      storage = local.storage_location_1
      size    = "10G"
    },
    # This will create disk scsi0 with writethrough cache enabled
    {
      type    = "scsi"
      storage = local.storage_location_2
      size    = "25G"
      cache   = "writethrough"
    }
  ]


  /*
    Create 3 Network Adapters
      - All adapters will be assigned model `virtio` and point to network bridge `vmbr0`.
          However, you can adjust these values as needed.
      - Network Adapter 1 (net0) - Set to DHCP
      - Network Adapter 2 (net1) - IP: 192.168.2.58/24 with gateway of 192.168.2.1
      - Network Adapter 3 (net2) - Set to DHCP
  */
  # Network Adapter net0 IP Configuration
  network_adapter_1 = {
    dhcp = true
  }
  network_model_1  = "virtio"
  network_bridge_1 = "vmbr0"

  # Network Adapter net1 IP Configuration
  network_adapter_2 = {
    # By default, DHCP is set to False if it isn't provided
    ip      = "192.168.2.58/24"
    gateway = "192.168.2.1"
  }
  network_model_2  = "virtio"
  network_bridge_2 = "vmbr0"

  # Network Adapter net2 IP Configuration
  network_adapter_3 = {
    # By default, DHCP is set to False if it isn't provided
    dhcp = true
  }
  network_model_3  = "virtio"
  network_bridge_3 = "vmbr0"
}
