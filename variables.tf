variable "agent" {
  description = "Set to 1 to enable the QEMU Guest Agent. Note, you must run the qemu-guest-agent daemon in the guest for this to have any effect."
  type        = number
  default     = 1

  validation {
    condition     = var.agent >= 0 && var.agent <= 1
    error_message = "Set to 1 to enable the QEMU Guest Agent or 0 to disable."
  }
}

variable "automatic_reboot" {
  description = "Automatically reboot the VM when parameter changes require this. If disabled the provider will emit a warning when the VM needs to be rebooted."
  type        = bool
  default     = true
}

variable "balloon" {
  description = "The minimum amount of memory to allocate to the VM in Megabytes, when Automatic Memory Allocation is desired. Proxmox will enable a balloon device on the guest to manage dynamic allocation. See the docs about memory for more info."
  type        = number
  default     = 0

  validation {
    condition     = var.balloon >= 0 && var.balloon <= 8000000
    error_message = "The minimum accepted balloon memory amount is 0 (Megabytes). The highest accepted amount is 8000000 (8 Terrabytes)"
  }
}

variable "bios" {
  description = "The BIOS to use, options are seabios or ovmf for UEFI."
  type        = string
  default     = "seabios"

  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "You must select one of the following types of BIOS: seabios, ovmf (aka UEFI)"
  }
}

variable "boot" {
  description = "The boot order for the VM. For example: order=scsi0;ide2;net0."
  type        = string
  default     = null
}

variable "bootdisk" {
  description = "Enable booting from specified disk. You shouldn't need to change it under most circumstances."
  type        = string
  default     = null
}

variable "ci_wait" {
  description = "How to long in seconds to wait for before provisioning."
  type        = number
  default     = 30
}

variable "cicustom" {
  description = "Instead specifying ciuser, cipasword, etc… you can specify the path to a custom cloud-init config file here. Grants more flexibility in configuring cloud-init."
  type        = string
  default     = null
}

variable "cipassword" {
  description = "Override the default cloud-init user's password. Sensitive."
  type        = string
  sensitive   = true
  default     = null
}

variable "ciuser" {
  description = "Override the default cloud-init user for provisioning."
  type        = string
  default     = null
}

variable "clone" {
  description = "The base VM from which to clone to create the new VM. Note that clone is mutually exclussive with pxe and iso modes."
  type        = string
}

variable "cloudinit_cdrom_storage" {
  description = "Set the storage location for the cloud-init drive. Required when specifying cicustom."
  type        = string
  default     = null
}

variable "cores" {
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  type        = number
  default     = 1

  validation {
    condition     = var.cores > 0 && var.cores <= 256
    error_message = "CPU Cores must be an integer greater than 0 and less than or equal to 256"
  }
}

variable "cpu" {
  description = "The type of CPU to emulate in the Guest. See the docs about CPU Types for more info."
  type        = string
  default     = "host"

  validation {
    condition     = contains(["host", "kvm32", "kvm64", "max", "qemu32", "qemu64"], var.cpu)
    error_message = "You must select one of the following types of CPU: host, kvm32, kvm64, max, qemu32, or qemu64"
  }
}

variable "create_vm" {
  description = "Controls if virtual machine should be created."
  type        = bool
  default     = true
}

variable "description" {
  description = "The description of the VM. Shows as the 'Notes' field in the Proxmox GUI."
  type        = string
  default     = ""
}

variable "disks" {
  description = "The disk(s) of the Virtual Machine."
  type = list(object({
    type               = string
    storage            = string
    size               = string
    format             = optional(string, "raw")
    cache              = optional(string, "none")
    backup             = optional(bool, false)
    iothread           = optional(number, 0)
    discard            = optional(number, 0)
    replicate          = optional(number, 0)
    ssd                = optional(number, 0)
    mbps               = optional(number, 0)
    mbps_rd            = optional(number, 0)
    mbps_rd_max        = optional(number, 0)
    mbps_wr            = optional(number, 0)
    mbps_wr_max        = optional(number, 0)
    iops               = optional(number, 0)
    iops_rd            = optional(number, 0)
    iops_rd_max        = optional(number, 0)
    iops_rd_max_length = optional(number, 0)
    iops_wr            = optional(number, 0)
    iops_wr_max        = optional(number, 0)
    iops_wr_max_length = optional(number, 0)
  }))

  validation {
    condition     = alltrue([for disk in var.disks : contains(["ide", "sata", "scsi", "virtio"], disk.type)])
    error_message = "Required The type of disk device to add. Options: ide, sata, scsi, virtio."
  }

  validation {
    condition     = alltrue([for disk in var.disks : can(regex("^\\d+[GMK]$", disk.size))])
    error_message = "The size of the created disk, format must match the regex \\d+[GMK], where G, M, and K represent Gigabytes, Megabytes, and Kilobytes respectively."
  }

  validation {
    condition     = alltrue([for disk in var.disks : contains(["cow", "cloop", "qcow", "qcow2", "qed", "vmdk", "raw"], disk.format)])
    error_message = "The drive’s backing file’s data format. Options are: 'cow, 'cloop', 'qcow', 'qcow2', 'qed', 'vmdk', 'raw'."
  }

  validation {
    condition     = alltrue([for disk in var.disks : contains(["directsync", "none", "unsafe", "writeback", "writethrough"], disk.cache)])
    error_message = "The drive’s cache mode. Options: directsync, none, unsafe, writeback, writethrough"
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iothread >= 0 && disk.iothread <= 1])
    error_message = "The only options for iothread are 0 and 1. To enable iothread, set this value to 1."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.replicate >= 0 && disk.replicate <= 1])
    error_message = "The only options for replicate are 0 and 1. To enable disk replication, set this value to 1."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.ssd == 0 || (disk.ssd >= 0 && contains(["ide", "sata", "scsi"], disk.type))])
    error_message = "The only valid options are 0 and 1. If you are not using a drive type of 'ide', 'sata', or 'scsi', set ssd to 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.discard >= 0 && disk.discard <= 1])
    error_message = "The only options are 0 and 1. To enable disk discard, set this value to 1. You may need to set ssd emulate to 1 as well. See https://pve.proxmox.com/pve-docs/chapter-qm.html#qm_hard_disk."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.mbps >= 0])
    error_message = "Maximum r/w speed in megabytes per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.mbps_rd >= 0])
    error_message = "Maximum read speed in megabytes per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.mbps_rd_max >= 0])
    error_message = "Maximum read speed in megabytes per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.mbps_wr >= 0])
    error_message = "Maximum write speed in megabytes per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.mbps_wr_max >= 0])
    error_message = "Maximum throttled write pool in megabytes per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iops >= 0])
    error_message = "Maximum r/w I/O in operations per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iops_rd >= 0])
    error_message = "Maximum read I/O in operations per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iops_rd_max >= 0])
    error_message = "Maximum unthrottled read I/O pool in operations per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iops_rd_max_length >= 0])
    error_message = "Maximum length of read I/O bursts in seconds. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iops_wr >= 0])
    error_message = "Maximum write I/O in operations per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iops_wr_max >= 0])
    error_message = "Maximum unthrottled write I/O pool in operations per second. Set to 0 for unlimited or set a value greater than 0."
  }

  validation {
    condition     = alltrue([for disk in var.disks : disk.iops_wr_max_length >= 0])
    error_message = "Maximum length of write I/O bursts in seconds. Set to 0 for unlimited or set a value greater than 0."
  }

  default = [{
    size    = "10G"
    storage = "local-pve"
    type    = "virtio"
  }]
}

variable "force_create" {
  description = "If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with these settings. Set to true to always create a new VM (note, the name of the VM must still be unique, otherwise an error will be produced.)."
  type        = bool
  default     = false
}

variable "force_recreate_on_change_of" {
  description = "If the value of this string changes, the VM will be recreated. Useful for allowing this resource to be recreated when arbitrary attributes change. An example where this is useful is a cloudinit configuration (as the cicustom attribute points to a file not the content)."
  type        = string
  default     = null
}

variable "full_clone" {
  description = "Set to true to create a full clone, or false to create a linked clone. See the docs about cloning for more info. Only applies when clone is set."
  type        = bool
  default     = true
}

variable "hagroup" {
  description = "The HA group identifier the resource belongs to (requires hastate to be set!)."
  type        = string
  default     = null
}

variable "hastate" {
  description = "Requested HA state for the resource. One of 'started', 'stopped', 'enabled', 'disabled', or 'ignored'. See the docs about HA for more info."
  type        = string
  default     = null
}

variable "hotplug" {
  description = "Comma delimited list of hotplug features to enable. Options: network, disk, cpu, memory, usb. Set to 0 to disable hotplug."
  type        = string
  default     = "cpu,network,disk,usb"
}

variable "memory" {
  description = "The amount of memory to allocate to the VM in Megabytes."
  type        = number
  default     = 1024

  validation {
    condition     = var.memory >= 10 && var.memory <= 8000000
    error_message = "The minimum accepted memory amount is 10 (Megabytes). The highest accepted amount is 8000000 (8 Terrabytes)"
  }
}

variable "nameserver" {
  description = "Sets default DNS server for guest."
  type        = string
  default     = null
}

variable "networks" {
  description = "The network adapters affiliated with the Virtual Machine."
  type = list(object({
    bridge    = optional(string, "nat")
    model     = optional(string, "virtio")
    gateway   = optional(string)
    gateway6  = optional(string)
    ip        = optional(string)
    ip6       = optional(string)
    dhcp      = optional(bool, false)
    dhcp6     = optional(bool, false)
    firewall  = optional(bool, false)
    link_down = optional(bool, false)
    macaddr   = optional(string)
    queues    = optional(number, 1)
    rate      = optional(number, 0)
    vlan_tag  = optional(number, -1)
  }))

  validation {
    condition     = alltrue([for network in var.networks : contains(["e1000", "e1000-82540em", "e1000-82544gc", "e1000-82545em", "i82551", "i82559er", "ne2k_isa", "ne2k_pci", "pcnet", "rtl8139", "virtio", "vmxnet3"], network.model)])
    error_message = "Required Network Card Model. The virtio model provides the best performance with very low CPU overhead. If your guest does not support this driver, it is usually best to use e1000. Options: e1000, e1000-82540em, e1000-82544gc, e1000-82545em, i82551, i82557b, i82559er, ne2k_isa, ne2k_pci, pcnet, rtl8139, virtio, vmxnet3."
  }

  validation {
    condition     = alltrue([for network in var.networks : network.macaddr == null || can(regex("^[a-fA-F0-9]{2}(:[a-fA-F0-9]{2}){5}$", network.macaddr))])
    error_message = "If you want to override the generated mac address, you must provide a mac address that fits the regular expression: ^[a-fA-F0-9]{2}(:[a-fA-F0-9]{2}){5}$"
  }

  validation {
    condition     = alltrue([for network in var.networks : network.queues >= 0 && network.queues <= 64])
    error_message = "Number of packet queues to be used on the device. Set a value between 0 and 64."
  }

  validation {
    condition     = alltrue([for network in var.networks : network.rate >= 0])
    error_message = "Rate limit in mbps (megabytes per second) as floating point number. Set a value of 0 or higher."
  }

  validation {
    condition     = alltrue([for network in var.networks : (network.vlan_tag == -1) || (network.vlan_tag >= 1 && network.vlan_tag <= 4094)])
    error_message = "VLAN tag to apply to packets on this interface. Set a value of 1 to 4094"
  }

  validation {
    condition     = length(var.networks) > 0 && length(var.networks) <= 16
    error_message = "You must have at least 1 network adapter and no less than 16 total adapters."
  }
}

variable "numa" {
  description = "Whether to enable Non-Uniform Memory Access in the guest."
  type        = bool
  default     = false
}

variable "onboot" {
  description = "Whether to have the VM startup after the PVE node starts."
  type        = bool
  default     = false
}

variable "oncreate" {
  description = "Whether to have the VM startup after the VM is created."
  type        = bool
  default     = true
}

variable "os_type" {
  description = "Which provisioning method to use, based on the OS type. Options: ubuntu, centos, cloud-init."
  type        = string
  default     = "cloud-init"

  validation {
    condition     = contains(["ubuntu", "centos", "e1000", "cloud-init"], var.os_type)
    error_message = "Incorrect OS type, your options are: ubuntu, centos, or cloud-init."
  }
}

variable "pool" {
  description = "The resource pool to which the VM will be added."
  type        = string
  default     = null
}

variable "qemu_os" {
  description = "The type of OS in the guest. Set properly to allow Proxmox to enable optimizations for the appropriate guest OS. It takes the value from the source template and ignore any changes to resource configuration parameter."
  type        = string
  default     = "l26"
}

variable "scsihw" {
  description = "The SCSI controller to emulate. Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single."
  type        = string
  default     = "virtio-scsi-pci"

  validation {
    condition     = contains(["lsi", "lsi53c810", "megasas", "pvscsi", "virtio-scsi-pci", "virtio-scsi-single"], var.scsihw)
    error_message = "You must select one of the following SCSI Controller Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, or virtio-scsi-single"
  }
}

variable "searchdomain" {
  description = "Sets default DNS search domain suffix."
  type        = string
  default     = null
}

variable "serials" {
  description = "Creates a serial device inside the Virtual Machine (up to a max of 4)."
  type = list(object({
    id   = optional(number)
    type = optional(string)
  }))

  default = []
}

variable "sockets" {
  description = "The number of CPU sockets for the Master Node."
  type        = number
  default     = 1

  validation {
    condition     = var.sockets > 0 && var.sockets <= 24
    error_message = "CPU Sockets must be an integer greater than 0 and less than or equal to 24"
  }
}

variable "sshkeys" {
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user."
  type        = string
  default     = null
}

variable "startup" {
  description = "The startup and shutdown behaviour"
  type        = string
  default     = ""
}

variable "tablet" {
  description = "Enable/disable the USB tablet device. This device is usually needed to allow absolute mouse positioning with VNC."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags of the VM. This is only meta information."
  type        = string
  default     = null
}

variable "target_node" {
  description = "The name of the Proxmox Node on which to place the VM."
  type        = string
}

variable "usbs" {
  description = "The usb block is used to configure USB devices. It may be specified multiple times."
  type = list(object({
    host = optional(string)
    usb3 = optional(bool)
  }))
  default = []
}

variable "vgas" {
  description = "The vga block is used to configure the display device. It may be specified multiple times, however only the first instance of the block will be used."
  type = list(object({
    type   = optional(string)
    memory = optional(number)
  }))
  default = []
}

variable "vm_name" {
  description = "The virtual machine name."
  type        = string
}

variable "vmid" {
  description = "The ID of the VM in Proxmox. The default value of 0 indicates it should use the next available ID in the sequence."
  type        = number
  default     = 0
}
