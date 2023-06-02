# Multi-Nic Ubuntu Virtual Machine Deployment

This example demonstrates how you would deploy a Virtual Machine with multiple network adapters using an Ubuntu Cloudinit template.

Network Adapter `net0` is set to DHCP.

Network Adapter `net1` has a static IP assigned.

Network Adapter `net2` has a static IP assigned, different network bridge, and has a tagged VLAN.

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

## Step 3. Modify Virtual Machine configuration

I've pre-configured a few network adapters residing in `locals.tf`. Feel free to mess around with the IP Addressing for each of the Network Adapters to understand the syntax. 

## Step 4. Deploy Virtual Machine

Run the following commands to deploy said Virtual Machine
```bash
terraform init
terraform plan
terraform apply
```

# Multiple-NICs Example Information

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
| <a name="module_multi_nic"></a> [multi\_nic](#module\_multi\_nic) | ../../ | n/a |

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
| <a name="output_proxmox_multi_nic_vm_id"></a> [proxmox\_multi\_nic\_vm\_id](#output\_proxmox\_multi\_nic\_vm\_id) | The Virtual Machine's Id. |
| <a name="output_proxmox_multi_nic_vm_ip"></a> [proxmox\_multi\_nic\_vm\_ip](#output\_proxmox\_multi\_nic\_vm\_ip) | The Virtual Machine's IP on the first Network Adapter. |
| <a name="output_proxmox_multi_nic_vm_name"></a> [proxmox\_multi\_nic\_vm\_name](#output\_proxmox\_multi\_nic\_vm\_name) | The Virtual Machine's name. |
| <a name="output_proxmox_multi_nic_vm_node"></a> [proxmox\_multi\_nic\_vm\_node](#output\_proxmox\_multi\_nic\_vm\_node) | The Proxmox Node the Virtual Machine was created on. |
| <a name="output_proxmox_multi_nic_vm_template"></a> [proxmox\_multi\_nic\_vm\_template](#output\_proxmox\_multi\_nic\_vm\_template) | The name of the template in which the Virtual Machine was created on. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
