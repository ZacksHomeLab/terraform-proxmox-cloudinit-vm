# Multi-Nic Ubuntu Virtual Machine Deployment
This example demonstrates how you would deploy a Virtual Machine with multiple network adapters using an Ubuntu Cloudinit template. This example will demonstrate how to deploy a Virtual Machine with three network adapters.

Network Adapter `net0` is set to DHCP.

Network Adapter `net1` has a static IP assigned.

Network Adapter `net2` has a static IP assigned.

<font size=5>FAILURE DEPLOYMENT WARNING</font>

NOTE: If your Virtual Machine template does ***NOT*** have the Cloudinit drive set to `ide2`, the Terraform provider may fail to provision your Virtual Machine.

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
```bash
terraform init
terraform plan
terraform apply
```