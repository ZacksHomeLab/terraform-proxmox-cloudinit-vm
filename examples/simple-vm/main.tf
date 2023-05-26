provider "proxmox" {
  #pm_tls_insecure = true
}

module "cloudinit_vm" {
  source = "../../"

  vm_name     = "ubuntu-simple-vm"
  target_node = local.target_node
  clone       = local.template

  description = "This is an example Virtual Machine."
  onboot      = true

  # Specs
  cores  = 1
  memory = 1024

  # Disk(s)
  scsihw = "virtio-scsi-pci"
  disks = [
    # Disk #1
    {
      type    = "virtio"
      storage = local.storage_location
      size    = "5G"
    }
  ]

  # Network Cards
  networks = [
    # NIC #1
    {
      model  = "virtio"
      bridge = "vmbr0"
    }
  ]

  # IP Configuration for NIC #1
  ipconfig0 = local.network_config
}
