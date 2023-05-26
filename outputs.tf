output "proxmox_vm_id" {
  # For example, if I had a VM id of "pvme1/qemu/114", this will return 114
  value = try(tonumber(element(split("/", proxmox_vm_qemu.cloudinit[0].id), length(split("/", proxmox_vm_qemu.cloudinit[0].id)) - 1)), "")
}

output "proxmox_vm_ip" {
  value = try(proxmox_vm_qemu.cloudinit[0].ssh_host, "")
}

output "proxmox_vm_name" {
  value = try(proxmox_vm_qemu.cloudinit[0].name, "")
}

output "proxmox_vm_template" {
  value = try(proxmox_vm_qemu.cloudinit[0].clone, "")
}

output "proxmox_vm_node" {
  value = try(proxmox_vm_qemu.cloudinit[0].target_node, "")
}
