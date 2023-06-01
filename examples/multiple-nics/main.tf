provider "proxmox" {
  #pm_tls_insecure = true
}

module "multi_nic" {
  source = "../../"

  vm_name     = "ubuntu-multi-nic-vm"
  target_node = var.target_node
  clone       = var.clone

  # Specs
  cores  = 1
  memory = 1024

  # Disk(s)
  scsihw = "virtio-scsi-pci"

  disks = [
    # Disk #1
    {
      type    = "virtio"
      storage = var.storage_location
      size    = "10G"
    }
  ]

  # Networks
  networks = local.networks
}
