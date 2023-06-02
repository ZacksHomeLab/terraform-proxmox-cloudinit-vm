# Terragrunt Wrapper for Root Module

The wrapper in this directory allows you to manage serveral co
This module allows you to provide multiple Virtual Machine deployments within a single `terragrunt.hcl` file. 

## Using this module in Terragrunt

This example demonstrates how you would deploy two Virtual Machines within the same `terragrunt.hcl`

```
terraform {
  source = "github.com/ZacksHomeLab/terraform-proxmox-cloudinit-vm//wrappers"
}

inputs = {

  # The arguments inside 'defaults' will be passed to 'vm-one' and 'vm-two'
  defaults = {
    create_vm = true

    # Set the default Target Node
    target_node = "pve1"

    # The name of the template to clone off of
    clone = "ubuntu2204"

    disks = [{
      storage = "local-pve"
      size    = "20G"
      type    = "virtio"
    }]

    network = [{
      dhcp   = true
      bridge = "vmbr0"
    }]

    tags = ["dev"]
  }

  items = {
    vm-one = {
      vm_name = "terragrunt-vm-1"
      # Any additional VM specific arguments
    }
    vm-two = {
      vm_name = "terragrunt-vm-2"
      # Any additional VM specific arguments
    }
  }
}
```

## Usage with Terraform

## Examples

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.14 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 2.9.14 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terragrunt_wrapper"></a> [terragrunt\_wrapper](#module\_terragrunt\_wrapper) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_defaults"></a> [defaults](#input\_defaults) | Map of default values that will be used for each provided item. | `any` | `{}` | no |
| <a name="input_items"></a> [items](#input\_items) | Maps of items to create a wrapper from. Values placed in this variable are passed to the Terragrunt module. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_proxmox_terragrunt_wrapper"></a> [proxmox\_terragrunt\_wrapper](#output\_proxmox\_terragrunt\_wrapper) | Output the contents of the Terragrunt Wrapper. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
