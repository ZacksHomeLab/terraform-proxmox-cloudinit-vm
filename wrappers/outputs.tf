output "disks" {
  description = "The Disk(s) affiliated with said Virtual Machine."
  value       = module.terragrunt_wrapper.disks
}

output "ip" {
  description = "The Virtual Machine's IP on the first Network Adapter."
  value       = module.terragrunt_wrapper.ip
}

output "name" {
  description = "The Virtual Machine's name."
  value       = module.terragrunt_wrapper.name
}

output "nics" {
  description = "The Network Adapter(s) affiliated with said Virtual Machine."
  value       = module.terragrunt_wrapper.nics
}

output "node" {
  description = "The Proxmox Node the Virtual Machine was created on."
  value       = module.terragrunt_wrapper.node
}

output "ssh" {
  description = "The Virtual Machine's SSH Settings."
  value       = module.terragrunt_wrapper.ssh_settings
  sensitive   = true
}

output "template" {
  description = "The name of the template in which the Virtual Machine was created on."
  value       = module.terragrunt_wrapper.template
}

output "vmid" {
  description = "The Virtual Machine's Id."
  value       = module.terragrunt_wrapper.vmid
}
