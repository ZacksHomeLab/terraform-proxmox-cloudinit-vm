output "proxmox_multi_nic_vm_id" {
  description = "The Virtual Machine's Id."
  value       = module.multi_nic.proxmox_vm_id
}

output "proxmox_multi_nic_vm_ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = module.multi_nic.proxmox_vm_ip
}

output "proxmox_multi_nic_vm_name" {
  description = "The Virtual Machine's name."
  value       = module.multi_nic.proxmox_vm_name
}

output "proxmox_multi_nic_vm_template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = module.multi_nic.proxmox_vm_template
}

output "proxmox_multi_nic_vm_node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = module.multi_nic.proxmox_vm_node
}
