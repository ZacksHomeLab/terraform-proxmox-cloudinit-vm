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

