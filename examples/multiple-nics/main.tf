provider "proxmox" {
  #pm_tls_insecure = true
}

module "cloudinit_vm" {
  source = "../../"

  vm_name     = "ubuntu-multi-nic-vm"
  target_node = var.target_node
  clone       = var.clone

  onboot = true

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

  # Network Cards
  networks = [
    # This will create Network Adapter net0
    {
      model  = local.network_model
      bridge = local.network_bridge
    },

    # This will create Network Adapter net1
    {
      model  = local.network_model
      bridge = local.network_bridge
    },

    # This will create Network Adapter net2
    {
      model  = local.network_model
      bridge = local.network_bridge
    }
  ]

  # IP Configuration for net0
  ipconfig0 = local.network_adapter_1
  ipconfig1 = local.network_adapter_2
  ipconfig2 = local.network_adapter_3
}
