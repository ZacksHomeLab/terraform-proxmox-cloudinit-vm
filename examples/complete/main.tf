provider "proxmox" {
  #pm_tls_insecure = true
}

module "cloudinit_vm" {
  source = "../../"

  vm_name     = "ubuntu-complete"
  target_node = var.target_node
  clone       = var.clone

  onboot = true

  # Specs
  cores  = local.cores
  memory = local.memory

  # Disk(s)
  scsihw = "virtio-scsi-pci"

  disks = local.disks

  # Network Cards
  networks = [
    # This will create Network Adapter net0
    {
      model  = local.network_model_1
      bridge = local.network_bridge_1
    },

    # This will create Network Adapter net1
    {
      model  = local.network_model_2
      bridge = local.network_bridge_2
    },

    # This will create Network Adapter net2
    {
      model  = local.network_model_3
      bridge = local.network_bridge_3
    }
  ]

  # IP Configuration for net0
  ipconfig0 = local.network_adapter_1
  ipconfig1 = local.network_adapter_2
  ipconfig2 = local.network_adapter_3


  # Cloudinit settings
  ciuser  = local.ciuser
  sshkeys = local.sshkeys != null ? local.sshkeys : null
}
