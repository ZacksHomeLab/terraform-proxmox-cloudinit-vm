resource "proxmox_vm_qemu" "cloudinit" {
  count = local.create_vm ? 1 : 0

  name        = var.vm_name
  target_node = var.target_node
  pool        = var.pool
  clone       = var.clone
  full_clone  = var.full_clone
  vmid        = var.vmid
  desc        = var.description
  os_type     = var.os_type

  bios                        = var.bios
  onboot                      = var.onboot
  startup                     = var.startup
  oncreate                    = var.oncreate
  automatic_reboot            = var.automatic_reboot
  force_create                = var.force_create
  force_recreate_on_change_of = var.force_recreate_on_change_of

  tablet   = var.tablet
  boot     = var.boot != null ? var.boot : null
  bootdisk = var.bootdisk != null ? var.bootdisk : null
  agent    = var.agent

  hastate = var.hastate != null ? var.hastate : null
  hagroup = var.hastate != null ? var.hagroup : null
  hotplug = var.hotplug
  scsihw  = var.scsihw
  qemu_os = var.qemu_os

  memory  = var.memory
  balloon = var.balloon

  sockets = var.sockets
  cores   = var.cores
  cpu     = var.cpu
  numa    = can(regex("memory", var.hotplug)) && var.numa ? var.numa : false

  # Disks
  dynamic "disk" {
    for_each = var.disks == null ? [] : var.disks
    content {
      type               = try(disk.value.type)
      storage            = try(disk.value.storage)
      size               = try(disk.value.size)
      format             = try(disk.value.format)
      cache              = try(disk.value.cache)
      backup             = try(disk.value.backup)
      iothread           = try(disk.value.iothread)
      replicate          = try(disk.value.replicate)
      mbps               = try(disk.value.mbps)
      mbps_rd            = try(disk.value.mbps_rd)
      mbps_rd_max        = try(disk.value.mbps_rd_max)
      mbps_wr            = try(disk.value.mbps_wr)
      mbps_wr_max        = try(disk.value.mbps_wr_max)
      iops               = try(disk.value.iops)
      iops_rd            = try(disk.value.iops_rd)
      iops_rd_max        = try(disk.value.iops_rd_max)
      iops_rd_max_length = try(disk.value.iops_rd_max_length)
      iops_wr            = try(disk.value.iops_wr)
      iops_wr_max        = try(disk.value.iops_wr_max)
      iops_wr_max_length = try(disk.value.iops_wr_max_length)
    }
  }

  # VGA Blocks
  dynamic "vga" {
    for_each = var.vgas == null ? [] : var.vgas
    content {
      type   = try(vga.value.vga_type, "std")
      memory = try(vga.value.memory)
    }
  }

  # Network Devices
  dynamic "network" {
    for_each = var.networks == null ? [] : var.networks
    content {
      model     = try(network.value.model)
      bridge    = try(network.value.bridge)
      firewall  = try(network.value.firewall)
      link_down = try(network.value.link_down)
      queues    = try(network.value.queues)
      rate      = try(network.value.rate)
      tag       = try(network.value.vlan_tag)
    }
  }

  # Serial Blocks
  dynamic "serial" {
    for_each = var.serials == null ? [] : var.serials
    content {
      id   = try(serial.value.id)
      type = try(serial.value.serial_type)
    }
  }

  # USB Blocks
  dynamic "usb" {
    for_each = var.usbs == null ? [] : var.usbs
    content {
      host = try(usb.value.host)
      usb3 = try(usb.value.usb3, false)
    }
  }

  # Cloud-Init Drive
  ciuser                  = var.ciuser != null ? var.ciuser : null
  cipassword              = var.cipassword != null ? var.cipassword : null
  cicustom                = var.cicustom != null ? var.cicustom : null
  ci_wait                 = var.ci_wait != null ? var.ci_wait : null
  cloudinit_cdrom_storage = var.cicustom != null && var.cloudinit_cdrom_storage != null ? var.cloudinit_cdrom_storage : null
  searchdomain            = var.searchdomain != null ? var.searchdomain : null
  nameserver              = var.nameserver != null ? var.nameserver : null
  sshkeys                 = var.sshkeys != null ? var.sshkeys : null


  # ipconfig area
  ipconfig0  = local.ipconfig0 != null ? local.ipconfig0 : null
  ipconfig1  = local.ipconfig1 != null ? local.ipconfig1 : null
  ipconfig2  = local.ipconfig2 != null ? local.ipconfig2 : null
  ipconfig3  = local.ipconfig3 != null ? local.ipconfig3 : null
  ipconfig4  = local.ipconfig4 != null ? local.ipconfig4 : null
  ipconfig5  = local.ipconfig5 != null ? local.ipconfig5 : null
  ipconfig6  = local.ipconfig6 != null ? local.ipconfig6 : null
  ipconfig7  = local.ipconfig7 != null ? local.ipconfig7 : null
  ipconfig8  = local.ipconfig8 != null ? local.ipconfig8 : null
  ipconfig9  = local.ipconfig9 != null ? local.ipconfig9 : null
  ipconfig10 = local.ipconfig10 != null ? local.ipconfig10 : null
  ipconfig11 = local.ipconfig11 != null ? local.ipconfig11 : null
  ipconfig12 = local.ipconfig12 != null ? local.ipconfig12 : null
  ipconfig13 = local.ipconfig13 != null ? local.ipconfig13 : null
  ipconfig14 = local.ipconfig14 != null ? local.ipconfig14 : null
  ipconfig15 = local.ipconfig15 != null ? local.ipconfig15 : null

  tags = var.tags != null ? join(",", var.tags) : null
}
