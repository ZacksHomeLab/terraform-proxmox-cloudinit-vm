variable "target_node" {
  description = "The name of the Proxmox Node on which to place the VM."
  type        = string
}

variable "clone" {
  description = "The base VM from which to clone to create the new VM. Note that clone is mutually exclussive with pxe and iso modes."
  type        = string
}

variable "storage_location" {
  description = "The storage location where your Virtual Machine will reside."
  type        = string
}
