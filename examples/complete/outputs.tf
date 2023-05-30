output "vm_id" {
  description = "The Virtual Machine's Id."
  value       = module.cloudinit_vm.proxmox_vm_id
}

output "vm_ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = module.cloudinit_vm.proxmox_vm_ip
}

output "vm_name" {
  description = "The Virtual Machine's name."
  value       = module.cloudinit_vm.proxmox_vm_name
}

output "vm_template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = module.cloudinit_vm.proxmox_vm_template
}

output "vm_node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = module.cloudinit_vm.proxmox_vm_node
}
