output "disks" {
  description = "The Disk(s) affiliated with said Virtual Machine."
  value       = module.multi_nic.disks
}

output "ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = module.multi_nic.ip
}

output "name" {
  description = "The Virtual Machine's name."
  value       = module.multi_nic.name
}

output "nics" {
  description = "The Network Adapter(s) affiliated with said Virtual Machine."
  value       = module.multi_nic.nics
}

output "node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = module.multi_nic.node
}

output "ssh" {
  description = "The Virtual Machine's SSH Settings."
  value       = module.multi_nic.ssh_settings
  sensitive   = true
}

output "template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = module.multi_nic.template
}

output "vmid" {
  description = "The Virtual Machine's Id."
  value       = module.multi_nic.vmid
}
