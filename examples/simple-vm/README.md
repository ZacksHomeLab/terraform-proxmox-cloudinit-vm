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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.14 |
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
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | The Virtual Machine's Id. |
| <a name="output_vm_ip"></a> [vm\_ip](#output\_vm\_ip) | The Virtual Machine's IP on the first Network Adapter. |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | The Virtual Machine's name. |
| <a name="output_vm_node"></a> [vm\_node](#output\_vm\_node) | The Proxmox Node the Virtual Machine was created on. |
| <a name="output_vm_template"></a> [vm\_template](#output\_vm\_template) | The name of the template in which the Virtual Machine was created on. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
