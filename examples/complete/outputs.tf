output "disks" {
  description = "The Disk(s) affiliated with said Virtual Machine."
  value       = module.cloudinit_vm.disks
}

output "ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = module.cloudinit_vm.ip
}

output "name" {
  description = "The Virtual Machine's name."
  value       = module.cloudinit_vm.name
}

output "nics" {
  description = "The Network Adapter(s) affiliated with said Virtual Machine."
  value       = module.cloudinit_vm.nics
}

output "node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = module.cloudinit_vm.node
}

output "ssh" {
  description = "The Virtual Machine's SSH Settings."
  value       = module.cloudinit_vm.ssh_settings
  sensitive   = true
}

output "template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = module.cloudinit_vm.template
}

output "vmid" {
  description = "The Virtual Machine's Id."
  value       = module.cloudinit_vm.vmid
}
