output "proxmox_cloudinit_vm_id" {
  description = "The Virtual Machine's Id."
  value       = module.cloudinit_vm.proxmox_vm_id
}

output "proxmox_cloudinit_vm_ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = module.cloudinit_vm.proxmox_vm_ip
}

output "proxmox_cloudinit_vm_name" {
  description = "The Virtual Machine's name."
  value       = module.cloudinit_vm.proxmox_vm_name
}

output "proxmox_cloudinit_vm_template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = module.cloudinit_vm.proxmox_vm_template
}

output "proxmox_cloudinit_vm_node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = module.cloudinit_vm.proxmox_vm_node
}
