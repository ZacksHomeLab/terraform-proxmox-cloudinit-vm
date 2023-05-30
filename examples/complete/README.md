# Complete Virtual Machine Deployment

This example demonstrates how you would deploy a Virtual Machine with multiple network adapters, multiple disks, and using an Ubuntu Cloudinit template.

***NOTE:*** If your Virtual Machine template does ***NOT*** have the Cloudinit drive set to `ide2`, the Terraform provider may fail to provision your Virtual Machine.

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

The values in `terraform.tfvars` illustrate using more than one storage location for your Virtual Machine. If you do **NOT** have multiple storage locations, just set both the values to the same datastore (e.g., local-pve). 

## Step 3. Modify Virtual Machine configuration

Once you've populated the required variables in `terraform.tfvars`, you may open `locals.tf` to see all of the settings that you may modify. I've populated the file with three different network adapters, two different disks, and I've started adding Cloudinit settings. 

Feel free to play around with these values to get a feel of how to deploy an out-of-ordinary Virtual Machine. 

## Step 4. Deploy Virtual Machine

Run the following commands to deploy said Virtual Machine
```bash
terraform init
terraform plan
terraform apply
```

# Complete Virtual Machine Deployment Information

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
| <a name="input_storage_location_1"></a> [storage\_location\_1](#input\_storage\_location\_1) | The location of where Disk 1 will be located. | `string` | n/a | yes |
| <a name="input_storage_location_2"></a> [storage\_location\_2](#input\_storage\_location\_2) | The location of where Disk 2 will be located. | `string` | n/a | yes |
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
