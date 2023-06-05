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
  boot     = var.boot
  bootdisk = var.bootdisk
  agent    = var.agent

  hastate = var.hastate
  hagroup = var.hastate != null && var.hagroup != null ? var.hagroup : ""
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
      type               = disk.value.type
      storage            = disk.value.storage
      size               = disk.value.size
      format             = disk.value.format
      cache              = disk.value.cache
      backup             = disk.value.backup
      iothread           = disk.value.iothread
      replicate          = disk.value.replicate
      mbps               = disk.value.mbps
      mbps_rd            = disk.value.mbps_rd
      mbps_rd_max        = disk.value.mbps_rd_max
      mbps_wr            = disk.value.mbps_wr
      mbps_wr_max        = disk.value.mbps_wr_max
      iops               = disk.value.iops
      iops_rd            = disk.value.iops_rd
      iops_rd_max        = disk.value.iops_rd_max
      iops_rd_max_length = disk.value.iops_rd_max_length
      iops_wr            = disk.value.iops_wr
      iops_wr_max        = disk.value.iops_wr_max
      iops_wr_max_length = disk.value.iops_wr_max_length
    }
  }

  # VGA Blocks
  dynamic "vga" {
    for_each = var.vgas == null ? [] : var.vgas
    content {
      type   = vga.value.vga_type
      memory = vga.value.memory
    }
  }

  # Network Devices
  dynamic "network" {
    for_each = var.networks == null ? [] : var.networks
    content {
      model     = network.value.model
      bridge    = network.value.bridge
      firewall  = network.value.firewall
      link_down = network.value.link_down
      queues    = network.value.queues
      rate      = network.value.rate
      tag       = network.value.vlan_tag
    }
  }

  # Serial Blocks
  dynamic "serial" {
    for_each = var.serials == null ? [] : var.serials
    content {
      id   = serial.value.id
      type = serial.value.serial_type
    }
  }

  # USB Blocks
  dynamic "usb" {
    for_each = var.usbs == null ? [] : var.usbs
    content {
      host = usb.value.host
      usb3 = usb.value.usb3
    }
  }

  # Cloud-Init Drive
  ciuser                  = var.ciuser
  cipassword              = var.cipassword
  cicustom                = var.cicustom
  ci_wait                 = var.ci_wait
  cloudinit_cdrom_storage = var.cicustom != null && var.cloudinit_cdrom_storage != null ? var.cloudinit_cdrom_storage : ""
  searchdomain            = var.searchdomain
  nameserver              = var.nameserver
  sshkeys                 = var.sshkeys


  # ipconfig area
  ipconfig0  = local.ipconfig0 != null ? local.ipconfig0 : ""
  ipconfig1  = local.ipconfig1 != null ? local.ipconfig1 : ""
  ipconfig2  = local.ipconfig2 != null ? local.ipconfig2 : ""
  ipconfig3  = local.ipconfig3 != null ? local.ipconfig3 : ""
  ipconfig4  = local.ipconfig4 != null ? local.ipconfig4 : ""
  ipconfig5  = local.ipconfig5 != null ? local.ipconfig5 : ""
  ipconfig6  = local.ipconfig6 != null ? local.ipconfig6 : ""
  ipconfig7  = local.ipconfig7 != null ? local.ipconfig7 : ""
  ipconfig8  = local.ipconfig8 != null ? local.ipconfig8 : ""
  ipconfig9  = local.ipconfig9 != null ? local.ipconfig9 : ""
  ipconfig10 = local.ipconfig10 != null ? local.ipconfig10 : ""
  ipconfig11 = local.ipconfig11 != null ? local.ipconfig11 : ""
  ipconfig12 = local.ipconfig12 != null ? local.ipconfig12 : ""
  ipconfig13 = local.ipconfig13 != null ? local.ipconfig13 : ""
  ipconfig14 = local.ipconfig14 != null ? local.ipconfig14 : ""
  ipconfig15 = local.ipconfig15 != null ? local.ipconfig15 : ""

  tags = var.tags != null ? join(",", var.tags) : ""

  lifecycle {
    # These cause a lot of problems if they're not ignored.
    ignore_changes = [ciuser, sshkeys, disk, network]
  }
}
