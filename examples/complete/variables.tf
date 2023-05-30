variable "storage_location_1" {
  description = "The location of where Disk 1 will be located."
  type        = string
}

variable "storage_location_2" {
  description = "The location of where Disk 2 will be located."
  type        = string
}

variable "target_node" {
  description = "The name of the Proxmox Node on which to place the VM."
  type        = string
}

variable "clone" {
  description = "The base VM from which to clone to create the new VM. Note that clone is mutually exclussive with pxe and iso modes."
  type        = string
}
