output "proxmox_terragrunt_wrapper" {
  description = "Output the contents of the Terragrunt Wrapper."
  value       = module.terragrunt_wrapper
  sensitive   = true
}
