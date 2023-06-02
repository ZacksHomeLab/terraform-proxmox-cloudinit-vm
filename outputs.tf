output "proxmox_vm_id" {
  description = "The Virtual Machine's Id."
  value       = try([for vm in proxmox_vm_qemu.cloudinit : tonumber(element(split("/", vm.id), length(split("/", vm.id)) - 1))], "")
}

output "proxmox_vm_ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = proxmox_vm_qemu.cloudinit[*].ssh_host
}

output "proxmox_vm_name" {
  description = "The Virtual Machine's name."
  value       = proxmox_vm_qemu.cloudinit[*].name
}

output "proxmox_vm_template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = proxmox_vm_qemu.cloudinit[*].clone
}

output "proxmox_vm_node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = proxmox_vm_qemu.cloudinit[*].target_node
}
