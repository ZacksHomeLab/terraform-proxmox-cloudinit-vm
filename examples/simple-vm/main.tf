provider "proxmox" {
  #pm_tls_insecure = true
}

module "cloudinit_vm" {
  source = "../../"

  vm_name     = "ubuntu-simple-vm"
  target_node = var.target_node
  clone       = var.clone

  description = "This is an example Virtual Machine."

  # Specs
  cores  = 1
  memory = 1024

  # Disk(s)
  disks = [
    {
      type    = "virtio"
      storage = var.storage_location
      size    = "10G"
    }
  ]

  # Network Cards
  networks = local.networks
}
