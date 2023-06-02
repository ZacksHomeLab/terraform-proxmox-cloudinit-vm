# Terragrunt Multi-VM Deployment
This example demonstrates how you would deploy multiple Virtual Machines in a single `terragrunt.hcl` using the provided Terragrunt wrapper.

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

Within `terragrunt.hcl`, you should notice the locals section:

```
/*
  UPDATE THESE VARIABLES TO MATCH YOUR ENVIRONMENT
*/
locals {
  vm1_target_node = "pve1"
  vm2_target_node = "pve2"

  # The name of the Virtual Machine clone
  vm1_clone = "ubuntu2204"
  vm2_clone = "ubuntu2210"

  # Locations to store said VM
  vm1_storage_location = "local-pve"
  vm2_storage_location = "other-storage-location"
}
```

Update the above variables to deploy two Virtual Machines within your environment.


## Step 3. Deploy Virtual Machines

Run the following commands in this directory to deploy
```bash
terragrunt init
terragrunt plan
terragrunt apply
```

# Terragrunt Multi-VM Deployment Information
