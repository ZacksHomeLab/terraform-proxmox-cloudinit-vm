output "vm_id" {
  value = try(module.cloudinit_vm.proxmox_vm_id)
}

output "vm_ip" {
  value = try(module.cloudinit_vm.proxmox_vm_ip)
}

output "vm_name" {
  value = try(module.cloudinit_vm.proxmox_vm_name)
}

output "vm_template" {
  value = try(module.cloudinit_vm.proxmox_vm_template)
}

output "vm_node" {
  value = try(module.cloudinit_vm.proxmox_vm_node)
}
