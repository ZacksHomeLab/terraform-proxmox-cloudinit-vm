variable "agent" {
  type        = number
  description = "Set to 1 to enable the QEMU Guest Agent. Note, you must run the qemu-guest-agent daemon in the guest for this to have any effect."
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
  type        = number
  description = "The minimum amount of memory to allocate to the VM in Megabytes, when Automatic Memory Allocation is desired. Proxmox will enable a balloon device on the guest to manage dynamic allocation. See the docs about memory for more info."
  default     = 0

  validation {
    condition     = var.balloon >= 0 && var.balloon <= 8000000
    error_message = "The minimum accepted balloon memory amount is 0 (Megabytes). The highest accepted amount is 8000000 (8 Terrabytes)"
  }
}

variable "bios" {
  type        = string
  description = "The BIOS to use, options are seabios or ovmf for UEFI."
  default     = "seabios"

  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "You must select one of the following types of BIOS: seabios, ovmf (aka UEFI)"
  }
}

variable "boot" {
  type        = string
  description = "The boot order for the VM. For example: order=scsi0;ide2;net0."
  default     = null
}

variable "bootdisk" {
  type        = string
  description = "Enable booting from specified disk. You shouldn't need to change it under most circumstances."
  default     = null
}

variable "ci_wait" {
  type        = number
  description = "How to long in seconds to wait for before provisioning."
  default     = 30
}

variable "cicustom" {
  type        = string
  description = "Instead specifying ciuser, cipasword, etc… you can specify the path to a custom cloud-init config file here. Grants more flexibility in configuring cloud-init."
  default     = null
}

variable "cipassword" {
  type        = string
  description = "Override the default cloud-init user's password. Sensitive."
  sensitive   = true
  default     = null
}

variable "ciuser" {
  type        = string
  description = "Override the default cloud-init user for provisioning."
  default     = null
}

variable "clone" {
  type        = string
  description = "The base VM from which to clone to create the new VM. Note that clone is mutually exclussive with pxe and iso modes."
  nullable    = false
}

variable "cloudinit_cdrom_storage" {
  type        = string
  description = "Set the storage location for the cloud-init drive. Required when specifying cicustom."
  default     = null
}

variable "cores" {
  type        = number
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  default     = 1

  validation {
    condition     = var.cores > 0 && var.cores <= 256
    error_message = "CPU Cores must be an integer greater than 0 and less than or equal to 256"
  }
}

variable "cpu" {
  type        = string
  description = "The type of CPU to emulate in the Guest. See the docs about CPU Types for more info."
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
  type        = string
  description = "The description of the VM. Shows as the 'Notes' field in the Proxmox GUI."
  default     = ""
}

variable "disks" {
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
}

variable "force_create" {
  type        = bool
  description = "If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with these settings. Set to true to always create a new VM (note, the name of the VM must still be unique, otherwise an error will be produced.)."
  default     = false
}

variable "force_recreate_on_change_of" {
  type        = string
  description = "If the value of this string changes, the VM will be recreated. Useful for allowing this resource to be recreated when arbitrary attributes change. An example where this is useful is a cloudinit configuration (as the cicustom attribute points to a file not the content)."
  default     = null
}

variable "full_clone" {
  type        = bool
  description = "Set to true to create a full clone, or false to create a linked clone. See the docs about cloning for more info. Only applies when clone is set."
  default     = true
}

variable "hagroup" {
  type        = string
  description = "The HA group identifier the resource belongs to (requires hastate to be set!)."
  default     = null
}

variable "hastate" {
  type        = string
  description = "Requested HA state for the resource. One of 'started', 'stopped', 'enabled', 'disabled', or 'ignored'. See the docs about HA for more info."
  default     = null
}

variable "hotplug" {
  type        = string
  description = "Comma delimited list of hotplug features to enable. Options: network, disk, cpu, memory, usb. Set to 0 to disable hotplug."
  default     = "cpu,network,disk,usb"
}

variable "ipconfig0" {
  description = "The 1st IP address to assign."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })

  default = {}
}

variable "ipconfig1" {
  description = "The 2nd IP address to assign."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })

  default = {}
}

variable "ipconfig2" {
  description = "The 3rd IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig3" {
  description = "The 4th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig4" {
  description = "The 5th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig5" {
  description = "The 6th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig6" {
  description = "The 7th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig7" {
  description = "The 8th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig8" {
  description = "The 9th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig9" {
  description = "The 10th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig10" {
  description = "The 11th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig11" {
  description = "The 12th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig12" {
  description = "The 13th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig13" {
  description = "The 14th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig14" {
  description = "The 15th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "ipconfig15" {
  description = "The 16th IP address to assign to this resource."
  type = object({
    IPv4Gateway = optional(string)
    IPv6Gateway = optional(string)
    IPv4Address = optional(string)
    IPv6Address = optional(string)
    DHCP        = optional(bool, false)
    DHCP6       = optional(bool, false)
  })
  default = {}
}

variable "iso" {
  type        = string
  description = "The name of the ISO image to mount to the VM in the format: [storage pool]:iso/[name of iso file]. Only applies when clone is not set. Either clone or iso needs to be set. Note that iso is mutually exclussive with clone and pxe modes."
  default     = null
}

variable "memory" {
  type        = number
  description = "The amount of memory to allocate to the VM in Megabytes."
  default     = 1024

  validation {
    condition     = var.memory >= 10 && var.memory <= 8000000
    error_message = "The minimum accepted memory amount is 10 (Megabytes). The highest accepted amount is 8000000 (8 Terrabytes)"
  }
}

variable "nameserver" {
  type        = string
  description = "Sets default DNS server for guest."
  default     = null
}

variable "networks" {
  type = list(object({
    model     = optional(string)
    bridge    = optional(string)
    firewall  = optional(bool)
    link_down = optional(bool)
    macaddr   = optional(string)
    mtu       = optional(number)
    queues    = optional(number)
    replicate = optional(number)
    rate      = optional(number)
    vlan_tag  = optional(number)
  }))
  default = []
}

variable "numa" {
  type        = bool
  description = "Whether to enable Non-Uniform Memory Access in the guest."
  default     = false
}

variable "onboot" {
  type        = bool
  description = "Whether to have the VM startup after the PVE node starts."
  default     = false
}

variable "oncreate" {
  type        = bool
  description = "Whether to have the VM startup after the VM is created."
  default     = true
}

variable "os_type" {
  type        = string
  description = "Which provisioning method to use, based on the OS type. Options: ubuntu, centos, cloud-init."
  default     = "cloud-init"

  validation {
    condition     = contains(["ubuntu", "centos", "e1000", "cloud-init"], var.os_type)
    error_message = "Incorrect OS type, your options are: ubuntu, centos, or cloud-init."
  }
}

variable "pool" {
  type        = string
  description = "The resource pool to which the VM will be added."
  default     = null
}

variable "pxe" {
  type        = bool
  description = "If set to true, enable PXE boot of the VM. Also requires a boot order be set with Network included (eg boot = 'order=net0;scsi0'). Note that pxe is mutually exclusive with iso and clone modes."
  default     = false
}

variable "qemu_os" {
  type        = string
  description = "The type of OS in the guest. Set properly to allow Proxmox to enable optimizations for the appropriate guest OS. It takes the value from the source template and ignore any changes to resource configuration parameter."
  default     = "l26"
}

variable "scsihw" {
  type        = string
  description = "The SCSI controller to emulate. Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single."
  default     = "virtio-scsi-pci"

  validation {
    condition     = contains(["lsi", "lsi53c810", "megasas", "pvscsi", "virtio-scsi-pci", "virtio-scsi-single"], var.scsihw)
    error_message = "You must select one of the following SCSI Controller Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, or virtio-scsi-single"
  }
}

variable "searchdomain" {
  type        = string
  description = "Sets default DNS search domain suffix."
  default     = null
}

variable "serials" {
  type = list(object({
    id   = optional(number)
    type = optional(string)
  }))
  default = []
}

variable "sockets" {
  type        = number
  description = "The number of CPU sockets for the Master Node."
  default     = 1

  validation {
    condition     = var.sockets > 0 && var.sockets <= 24
    error_message = "CPU Sockets must be an integer greater than 0 and less than or equal to 24"
  }
}

variable "sshkeys" {
  type        = string
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user."
  default     = null
}

variable "startup" {
  type        = string
  description = "The startup and shutdown behaviour"
  default     = ""
}

variable "tablet" {
  type        = bool
  description = "Enable/disable the USB tablet device. This device is usually needed to allow absolute mouse positioning with VNC."
  default     = true
}

variable "tags" {
  type        = string
  description = "Tags of the VM. This is only meta information."
  default     = null
}

variable "target_node" {
  type        = string
  description = "The name of the Proxmox Node on which to place the VM."
  nullable    = false
}

variable "usbs" {
  type = list(object({
    host = optional(string)
    usb3 = optional(bool)
  }))
  default = []
}

variable "vgas" {
  type = list(object({
    type   = optional(string)
    memory = optional(number)
  }))
  default = []
}

variable "vm_name" {
  type        = string
  description = "The virtual machine name."
  nullable    = false
}

variable "vmid" {
  type        = number
  description = "The ID of the VM in Proxmox. The default value of 0 indicates it should use the next available ID in the sequence."
  default     = 0
}
