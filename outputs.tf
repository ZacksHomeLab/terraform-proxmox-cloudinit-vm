output "proxmox_vm_id" {
  description = "The Virtual Machine's Id."
  # For example, if I had a VM id of "pvme1/qemu/114", this will return 114
  value = try(tonumber(element(split("/", proxmox_vm_qemu.cloudinit[0].id), length(split("/", proxmox_vm_qemu.cloudinit[0].id)) - 1)), "")
}

output "proxmox_vm_ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = proxmox_vm_qemu.cloudinit[0].ssh_host
}

output "proxmox_vm_name" {
  description = "The Virtual Machine's name."
  value       = proxmox_vm_qemu.cloudinit[0].name
}

output "proxmox_vm_template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = proxmox_vm_qemu.cloudinit[0].clone
}

output "proxmox_vm_node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = proxmox_vm_qemu.cloudinit[0].target_node
}
