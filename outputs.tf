output "disks" {
  description = "The Disk(s) affiliated with said Virtual Machine."
  value       = var.create_vm ? { for i, disk in proxmox_vm_qemu.cloudinit[0].disk : i => disk } : null
}

output "ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = var.create_vm ? proxmox_vm_qemu.cloudinit[0].default_ipv4_address : null
}

output "name" {
  description = "The Virtual Machine's name."
  value       = var.create_vm ? proxmox_vm_qemu.cloudinit[0].name : null
}

output "nics" {
  description = "The Network Adapter(s) affiliated with said Virtual Machine."
  value       = var.create_vm ? { for i, network in proxmox_vm_qemu.cloudinit[0].network : i => network } : null
}

output "node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = var.create_vm ? proxmox_vm_qemu.cloudinit[0].target_node : null
}

output "ssh_settings" {
  description = "The Virtual Machine's SSH Settings."
  value = var.create_vm ? {
    ssh_host = try(proxmox_vm_qemu.cloudinit[0].ssh_host, "")
    ssh_port = try(proxmox_vm_qemu.cloudinit[0].ssh_port, "")
    ssh_user = try(proxmox_vm_qemu.cloudinit[0].ssh_user != null ? proxmox_vm_qemu.cloudinit[0].ssh_user : proxmox_vm_qemu.cloudinit[0].ciuser, "")
    sshkeys  = try(proxmox_vm_qemu.cloudinit[0].sshkeys, "")
  } : null

  sensitive = true
}

output "template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = var.create_vm ? proxmox_vm_qemu.cloudinit[0].clone : null
}

output "vmid" {
  description = "The Virtual Machine's Id."
  value       = var.create_vm ? tonumber(element(split("/", proxmox_vm_qemu.cloudinit[0].id), length(split("/", proxmox_vm_qemu.cloudinit[0].id)) - 1)) : null
}
