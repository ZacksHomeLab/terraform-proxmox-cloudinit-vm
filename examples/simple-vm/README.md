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

## Step 2. Modify Virtual Machine configuration

Open `locals.tf`. At the bare minimum, you need to adjust these variables:

```
  # What node should the VM be deployed to?
  target_node = "pve1"

  # What's the name of the Virtual Machine template that will be used to create a clone of?
  template = "ubuntu-2204"

  # Virtual Machine Storage Location
  storage_location = "local-pve"
```

## Step 3. Deploy Virtual Machine

Run the following commands to deploy said Virtual Machine
```
terraform init
terraform plan
terraform apply
```

