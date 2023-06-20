# Simple Ubuntu Cloudinit VM Deployment
This example demonstrates how you would deploy a Virtual Machine using an Ubuntu Cloudinit template. 

## Step 1. Configure Terraform environment variables

Example 1: Using token and secret
```bash
# Using API Token & Secret example:
export PM_API_URL="https://pve1.yourdomain.com:8006/api2/json"
export PM_API_TOKEN_ID="svc-acc-terraform@pam!svc-acc-token-id"
export PM_API_TOKEN_SECRET="12341234-1234-1234-1234-123412341234"
```

Example 2: Using username and password
```bash
# Using username and password example:
export PM_API_URL="https://pve1.yourdomain.com:8006/api2/json"
export PM_USER="svc-acc-terraform@pam"
export PM_PASS="proxmox_account_password"
```

## Step 2. Modify Variables

Rename `terraform.tfvars.example` to `terraform.tfvars`. Once renamed, modify the three variables within the file to match your environment.


## Step 3. Modify Virtual Machine configuration

I've pre-configured a network adapter residing in `locals.tf`. Feel free to change the settings of said adapter to get a feel of the syntax. 

## Step 4. Deploy Virtual Machine

Run the following commands to deploy said Virtual Machine
```bash
terraform init
terraform plan
terraform apply
```

# Simple Virtual Machine Example Information

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 2.9.14 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudinit_vm"></a> [cloudinit\_vm](#module\_cloudinit\_vm) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_clone"></a> [clone](#input\_clone) | The base VM from which to clone to create the new VM. Note that clone is mutually exclussive with pxe and iso modes. | `string` | n/a | yes |
| <a name="input_storage_location"></a> [storage\_location](#input\_storage\_location) | The storage location where your Virtual Machine will reside. | `string` | n/a | yes |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | The name of the Proxmox Node on which to place the VM. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_disks"></a> [disks](#output\_disks) | The Disk(s) affiliated with said Virtual Machine. |
| <a name="output_ip"></a> [ip](#output\_ip) | The Virtual Machine's IP on the first Network Adapter. |
| <a name="output_name"></a> [name](#output\_name) | The Virtual Machine's name. |
| <a name="output_nics"></a> [nics](#output\_nics) | The Network Adapter(s) affiliated with said Virtual Machine. |
| <a name="output_node"></a> [node](#output\_node) | The Proxmox Node the Virtual Machine was created on. |
| <a name="output_ssh"></a> [ssh](#output\_ssh) | The Virtual Machine's SSH Settings. |
| <a name="output_template"></a> [template](#output\_template) | The name of the template in which the Virtual Machine was created on. |
| <a name="output_vmid"></a> [vmid](#output\_vmid) | The Virtual Machine's Id. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
