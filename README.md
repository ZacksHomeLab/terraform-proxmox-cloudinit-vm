# Terraform Module for Proxmox Cloudinit Virtual Machines

This Terraform module was created to deploy Cloudinit Virtual Machines to Proxmox Node(s). 

## Table of content

- [Table of content](#table-of-content)
- [Getting started](#getting-started)
  - [Step 1. Access Proxmox Shell](#step-1-access-proxmox-shell)
  - [Step 2. Download Ubuntu 22.04 image](#step-2-download-ubuntu-2204-image)
  - [Step 3. Install QEMU Agent](#step-3-install-qemu-agent)
  - [Step 4. Configure Virtual Machine](#step-4-configure-virtual-machine-template)
  - [Step 5. Convert Virtual Machine to Template](#step-5-convert-virtual-machine-to-template)
- [Using this module](#using-this-module)
  - [Disk configurations](#disk-configurations)
  - [Network Adapter configurations](#network-adapter-configurations)
  - [Cloudinit configurations](#cloudinit-configurations)
- [Common Issues](#common-issues)
  - [Issue: Terraform timing out](#issue-terraform-timing-out)
  - [Issue: Cloudinit drive already exists](#issue-cloudinit-drive-already-exists)
  - [Issue: Terraform expects Cloudinit changes](#issue-terraform-expects-cloudinit-changes)
  - [Issue: Terraform Promox provider crashing](#issue-terraform-proxmox-provider-crashing)

## Getting started
You must have an image, iso, template, or Clone that supports Cloudinit and has QEMU Guest Agent installed. 

If you **DO NOT** have QEMU Guest Agent installed on your image, iso, template, or clone, Terraform will timeout during said deployment while responding with `500` status codes as it cannot see the IP Address of said machine.

Follow the below steps to create your own Virtual Machine template that will work with this module.


### Step 1. Access Proxmox Shell
* First, we'll need to access our node's shell. 
* Log into your Proxmox's node via SSH or Web Browser

### Step 2. Download Ubuntu 22.04 image
* We will need a cloudinit-based image. In this example, I will be downloading Ubuntu 22.04 (Jammy). For other releases, you can retrieve said URL from Ubuntu's images website [here](https://cloud-images.ubuntu.com).
* Download the image
  
```bash
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```

### Step 3. Install QEMU Agent
* We're required to install QEMU Agent on our image for Terraform to work with Proxmox. To achieve this, we'll need to download a package on our Proxmox node. Run the following command

```bash
apt-get -y install libguestfs-tools
```
* Once installed, install QEMU Agent into your downloaded image
  
```bash
virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent
```
* (OPTIONAL): If you're **NOT** using an SSL Certificate within Cloudinit drive on said Virtual Machine, you'll need to modify SSH in said image to allow local authentication, which can be done running said command
  
```bash
virt-customize -a jammy-server-cloudimg-amd64.img --run-command "touch /etc/ssh/ssh_config.d/ssh_changes.conf && sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/ssh_config.d/ssh_changes.conf"
```

### Step 4. Configure Virtual Machine Template

With our image downloaded, QEMU Agent installed, and (optionally) SSH configured, we can now create our template in Proxmox.

First, we'll need to set our environment variables for this process. Modify these variables to meet your needs:

```bash
export STORAGE_POOL="local-lvm"
export VM_ID="900"
export VM_NAME="ubuntu2204"
```

With our variables created, we can move onward to create the virtual machine in Proxmox.

Create the Virtual Machine with 2GB of RAM, create a `virtio` network adapter `net0`, and set it to bridge `vmbr0`
  
```bash
qm create $VM_ID --memory 1024 --net0 virtio,bridge=vmbr0
```

Import the Virtual Machine's disk into the provided Storage Pool (this will allow us to see the VM in Proxmox's Web-UI)

```bash
qm importdisk $VM_ID jammy-server-cloudimg-amd64.img $STORAGE_POOL
```

Set the Virtual Machine's name, enable QEMU Guest Agent, and enable trimming of the disk upon cloning

```bash
qm set $VM_ID --name $VM_NAME && \
qm set $VM_ID --agent enabled=1,fstrim_cloned_disks=1
```

The following commands will perform the following:
* Add a CD-ROM to `ide0` (in case you need to reinstall the Virtual Machine at a later date)
* Add a Cloudinit drive to `ide2`
* Set the boot order to `CD-ROM (ide0) -> Disk (virtio0) -> Network Adapter (net0)` and set the bootdisk to disk `virtio0`
* Set the OS Type to `Linux: 6.x - 2.6 Kernel` 
* Add a serial adapter `serial0` and update our display to `serial0`
* (Optional): Set CPU Type to `host`. This is necessary if you plan on running any sort of nested virtualization on said Virtual Machine (e.g., Docker, Hyper-V, etc.)
```bash
qm set $VM_ID --ide0 file=none && \
qm set $VM_ID --ide2 $STORAGE_POOL:cloudinit && \
qm set $VM_ID --boot "order=ide0;virtio0;net0" --bootdisk virtio0 && \
qm set $VM_ID --ostype l26 && \
qm set $VM_ID --serial0 socket --vga serial0

# Optional
qm set $VM_ID --cpu cputype=host
```

<font size=5> Cloudinit Settings</font>

With our template mostly configured, we can set Cloudinit settings

If you are using a username/password for authentication or would like to use a different username and password instead of the Cloudinit defaults, you can do so by setting these two environment variables

```bash
export CI_USER="administrator"
export CI_PASS="my_admin_password"
```

Add these options to your Cloudinit template by running

```bash
qm set $VM_ID --ciuser $CI_USER --cipassword $CI_PASS
```

(Optional) If you want to utilize SSL for SSH, you'll need to add your SSH file to your Cloudinit template. On your machine that will be connecting to said Virtual Machines using said template, you'll need to either:
* Retrieve SSH Key
* Generate SSH Key

<font size=4>Option 1. Retrieve SSH Key</font>

To retrieve the public SSH key on your machine, there's two common areas where said key will reside:
* On Linux: `cat ~/.ssh/id_rsa.pub`
* On Windows: `type %USERPROFILE%\.ssh\id_rsa.pub`

The above command(s) will geenerate something along the lines of

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXTcvRHItt6hRmWq3q5UbtDsg6byjJMm/6gApTiDj46caI7DfYZ+EI3Yi+LZJC7/M+fZLP+bRQVWo7ZG/IuWIp2fy1JzafSSlnoZo/hexeD3dzkn3ERPA6QJlHoVR7fyMxwhqMT0IPmc10Werv8Etd4W0Kq7fY1j1L33aCADe4WsOrXEorU4qxSjSbc0KbVc4j6NYcWDYakZ+PzUTDIyDyMLutUgM1BYcZ63kKNUDdUXmymE7SjpvdNk7....= zack@zackshomelab.com
```

<font size=4>Option 2. Generate SSH Key</font>

If you do NOT have a public SSH key, you can create one by running the following command on your system

```bash
ssh-keygen -t rsa -b 4096
```

The above command should output where the file will be located. Once you run said command, you can follow steps under `Option 1. Retrieve SSH Key`

<font size=4>Add SSH Key to Cloudinit Template</font>

With our SSH key retrieved, we will need to create a temporary file on our Proxmox host to add said key into our template. Run the following command to create a temporary file with the contents of your `id_rsa.pub` file

```bash
# Replace the contents between the 'EOF' and EOF with your public SSH Key
tee /tmp/id_rsa.pub <<'EOF'
YOUR_PUBLIC_SSH_KEY_INFO_HERE
EOF
```

Example of what mine would look like:

```bash
tee /tmp/id_rsa.pub <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxxUTK7ZgN8F7r+HZRUy6z2EhaCMYcS+LkeTl9JaW/XzZrzGplDf+uTv0ZCBpDs0wl23zAukDOrG0hnLENs/liwxM/LZMcDEy8WMcBVS4UJzJNpMpAEdJiERvC+3bN36F7EMhAchVj0evqHqjjk3Dcre5CvwarRs9BG/YZKC25ZsraoEMAWIeTi6G5sMk3qUvRW+0kGjzJxNOs8/JeXq5++xKP7RyxGBjTeIHltawgT06yFtFWIh0/6GU8hdQJ3LKHch9PowSspTfUvR//CFCRGcavEnoGBqOtNHC1plpCcdr51yiLLPBwhXlsxKaMGA2YbmpUB4BFDFdLXteaGVtQvFukIlPiYCJNoFRR62xKGrW0a3B8i1RBNKnZH4SswsIyJfEIduwI4DGE2vZNH1sqJXRAx4mK3Z9l3srW2zhYDcSpi7SlpfVVF/XYishDApFLf8Vh44sukffImA7LnyFi8lRFdsKJOL4t03XFUMdpVyv21fTe9B9eyFjs9EivXEh2MUiI9mJfwHfphxMnsA07pAQKv7ykhil4KgdoDj3jM2ypvDLhIRHaw+1dgZftlimF68cLPRmrqAgHusouu5t/T7IX8RBPXrtLoMp50EF2g6bDkoJFhH9FG9mf5EFfUpen3NPc+WWDk5qOoe5Zc5ZuLPTIXxYJpub5kQhBNXoSXQ== zackshomelab\zack@ZHLDT01
EOF
```

With `/tmp/id_rsa.pub` created, add the SSH key to your template

```bash
qm set $VM_ID --sshkeys /tmp/id_rsa.pub
```

<font size=4>Cloudinit Network Settings</font>

You can preconfigure network settings for your Cloudinit template by setting the following options (NOTE: if searchdomain or namserver are NOT set, it will use the Proxmox Host's settings)

```bash
export SEARCH_DOMAIN='yourdomain.com'
# If you have more than one DNS Server, you can't use a variable.
export DNS_SERVER="192.168.1.2"
export IP_CONFIG="ip=dhcp"

qm set $VM_ID --searchdomain $SEARCH_DOMAIN --nameserver $DNS_SERVER --ipconfig0 $IP_CONFIG
```

```bash
# Example using more than one DNS Server
qm set $VM_ID --searchdomain $SEARCH_DOMAIN --nameserver "192.168.1.2 192.168.1.3" --ipconfig0 $IP_CONFIG
```

### Step 5. Convert Virtual Machine to Template

With our Virtual Machine configured, the last step would be to convert our Virtual Machine to a template, which we can do by running the following command

```bash
qm template $VM_ID
```

Once the Virtual Machine has been converted, you're ready to use this module!

[Back to Table of content](#table-of-content)


## Using this module

Checkout the examples in the example directory on how to use this module. To view various configurations, keep scrolling!

### Disk Configurations

You can have one or many disks for a Virtual Machine. Here's a couple examples:

**Example 1: Single Disk**

```
disks = [
  {
    type    = "virtio"
    storage = "local-pve"
    size    = "10G"
    format  = "raw"
    cache   = "none"
    backup  = true
  }
]
```

**Example 2: Multiple Disks**

```
disks = [
  # This will create disk virtio0
  {
    type =   "virtio"
    storage = "local-pve"
    size    = "10G"
  },
  # This will create disk scsi0
  {
    type    = "scsi"
    storage = "other-storage-location"
    size    = "25G"
    cache   = "writethrough"
  }
]
```

**Example 3: Full Disk Config**

```
disks = [
  # This will create disk virito0
  {
    type               = "virtio"
    storage            = "local-pve"
    size               = "10G"
    format             = "raw"
    cache              = "none"
    backup             = false
    iothread           = 0
    replicate          = 0
    mbps               = 0
    mbps_rd            = 0
    mbps_rd_max        = 0
    mbps_wr            = 0
    mbps_wr_max        = 0
    iops               = 0
    iops_rd            = 0
    iops_rd_max        = 0
    iops_rd_max_length = 0
    iops_wr            = 0
    iops_wr_max        = 0
    iops_wr_max_length = 0
  }
]
```

[Reference Documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#disk-block)

[Back to Table of content](#table-of-content)

### Network Adapter configurations

You may have up to 16 Network Adapters on your Virtual Machine. You first need to create a network adapter and give it a `type` and `bridge`. Once the network adapter is created, you can assign it a specific IP Configuration by setting `ipconfiX` where `X` is the network adapter (the counter starts at `0` and ends at `15`). For example, if you have one network adapter, you would assign its IP configuration to `ipconfig0`. (See below examples)

NOTE: If you set these adapters to use `DHCP`, `DHCP` takes priority over static assigned IP Addresses.


**Example 1. Single Network Adapter**

This example will create network adapter `net0` and assign it a DHCP address:
```
  networks = [
    # This will create Network Adapter net0
    {
      model  = "virtio"
      bridge = "vmbr0"
    }
  ]

  # IP Configuration for net0
  ipconfig0 = {
    DHCP = true
  }
```

**Example 2. Multiple Network Adapters**

This example demonstrates how to configure 3 network adapters (`net0`, `net1`, and `net2`):
* `net0` adapter will be configured with DHCP
* `net1` adapter will be configured with a Static IP
* `net2` adapter will be configured with both IPv4 & IPv6 DHCP Addresses

```
  # Network Cards
  networks = [
    # This will create Network Adapter net0
    {
      model  = "virtio"
      bridge = "vmbr0"
    },

    # This will create Network Adapter net1
    {
      model  = "virtio"
      bridge = "vmbr0"
    },

    # This will create Network Adapter net2
    {
      model  = "virtio"
      bridge = "vmbr0"
    }
  ]

  # IP Configuration for net0
  ipconfig0 = {
    DHCP = true
  }

  # IP Configuration for net1
  ipconfig1 = {
    IPv4Address = "192.168.1.3/24"
    IPv4Gateway = "192.168.1.1"
    #IPv6Address = ""
    #IPv6Gateway = ""
  }

  # IP Configuration for net2
  ipconfig2 = {
    DHCP  = true
    DHCP6 = true
  }
```

**Example 3. Full Network Adapter Config**

This example will show all of the options that a network adapter can be configured with.

```

networks = [
  {
    model     = "virtio"
    bridge    = "vmbr0"
    firewall  = true
    link_down = false
    macaddr   = ""
    queues    = 0
    rate      = 0
    vlan_tag  = 25
  }
]

ipconfig0 = {
  IPv4Gateway = "192.168.1.1"
  IPv6Gateway = "2001::1"
  IPv4Address = 192.168.1.254/24
  IPv6Address = "2607:f8b0:4000:808::200e"
  DHCP        = false
  DHCP6       = false
}
```
[Reference Documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#network-block)

[Back to Table of content](#table-of-content)

### Cloudinit Configurations

I highly recommend reading section [Issue: Terraform expects Cloudinit changes](#issue-terraform-expects-cloudinit-changes) on how to properly implement Cloudinit settings.


[Reference Documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu#provision-through-cloud-init)

[Back to Table of content](#table-of-content)

## Common Issues

### **Issue: Terraform timing out**

If you run this Terraform module and notice Terraform timing out (IIRC 5 minutes), you may have forgotten to install QEMU Guest Agent or QEMU Guest Agent is NOT enabled on your Virtual Machine template. If you export the following variable

```bash
export TF_LOG=TRACE
```

Terraform should display status code `500`.

### **Issue: Cloudinit drive already exists**

From my testing, if you have your Cloudinit drive on anything other than `ide2`, you may experience the following error

```
Cloudinit drive already exists on drive ...
```

This error occurs frequenly when you try to add additonal hardware that was **NOT** present with your Virtual Machine template. To resolve this, you may need to adjust your Virtual Machine template and have the Cloudinit drive mounted to `ide2`. [Follow the steps under `Getting Started`.](#getting-started)

### **Issue: Terraform expects Cloudinit changes**

If your Virtual Machine template has preconfigured Cloudinit settings For example:

![](2023-05-26-00-35-49.png)

and you do **NOT** mention these settings in your Terraform code, Terraform will see this as a `change` and will attempt to do so:

```
Terraform will perform the following actions:

  # module.cloudinit_vm.proxmox_vm_qemu.cloudinit[0] will be updated in-place
  ~ resource "proxmox_vm_qemu" "cloudinit" {
      - ciuser                    = "zack" -> null

Plan: 0 to add, 1 to change, 0 to destroy.
```


However, Terraform will not be able to modify said settings after the deployment, **BUT**, it will always see that changes need to be made for your Virtual Machine(s).

To prevent this issue, you **MUST** have these Cloudinit settings referenced in your Terraform code. For example, to match my provided screenshot, I would have the following references in my Terraform code

```hcl
  # In main.tf
  ciuser       = var.ciuser
  searchdomain = var.searchdomain
  nameserver   = var.nameserver
  sshkeys      = var.sshkeys
```

```hcl
  # in variables.tfvars
  ciuser       = 'zack'
  searchdomain = 'zackshomelab.com'
  nameserver   = '192.168.2.15 192.168.2.16'
  sshkeys      = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxxUTK7ZgN8F7r+HZRUy6z2EhaCMYcS+LkeTl9JaW/XzZrzGplDf+uTv0ZCBpDs0wl23zAukDOrG0hnLENs/liwxM/LZMcDEy8WMcBVS4UJzJNpMpAEdJiERvC+3bN36F7EMhAchVj0evqHqjjk3Dcre5CvwarRs9BG/YZKC25ZsraoEMAWIeTi6G5sMk3qUvRW+0kGjzJxNOs8/JeXq5++xKP7RyxGBjTeIHltawgT06yFtFWIh0/6GU8hdQJ3LKHch9PowSspTfUvR//CFCRGcavEnoGBqOtNHC1plpCcdr51yiLLPBwhXlsxKaMGA2YbmpUB4BFDFdLXteaGVtQvFukIlPiYCJNoFRR62xKGrW0a3B8i1RBNKnZH4SswsIyJfEIduwI4DGE2vZNH1sqJXRAx4mK3Z9l3srW2zhYDcSpi7SlpfVVF/XYishDApFLf8Vh44sukffImA7LnyFi8lRFdsKJOL4t03XFUMdpVyv21fTe9B9eyFjs9EivXEh2MUiI9mJfwHfphxMnsA07pAQKv7ykhil4KgdoDj3jM2ypvDLhIRHaw+1dgZftlimF68cLPRmrqAgHusouu5t/T7IX8RBPXrtLoMp50EF2g6bDkoJFhH9FG9mf5EFfUpen3NPc+WWDk5qOoe5Zc5ZuLPTIXxYJpub5kQhBNXoSXQ== zackshomelab\zack@ZHLDT01
EOF
```

If done correctly, you should see the following results upon running

```bash
terraform plan -lock=false
```

```
module.cloudinit_vm.proxmox_vm_qemu.cloudinit[0]: Refreshing state... [id=pve1/qemu/113]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```


### **Issue: Terraform Proxmox provider crashing**

During development of this module, I've encountered numerous Proxmox provider crashes. All of them have all happened during the creation of the VMDisk(s). 


<font size=4>Crash 1. Incorrect disk hardware</font>

It is ***VERY*** important that you configure the correct `scsihw` associated with the type of disk that you have. 

For example, this is a correct configuration:

```hcl
  scsihw = 'virtio-scsi-pci'

  disks = [
    # Disk #1
    {
      type    = "virtio"
      storage = "pve1-zfs"
      size    = "20G"
    }
  ]
```

This is an ***INCORRECT*** configuration (disk type `virtio` must match `scsihw = 'virtio-scsi-pci'`. It is not compatible with `scsihw = 'lsi'`):

```hcl
  scsihw = 'lsi'

  disks = [
    # Disk #1
    {
      type    = "virtio"
      storage = "pve1-zfs"
      size    = "20G"
    }
  ]
```

<font size=4>Crash 2. SSD Emulation</font>

Removed from this module is configuring SSD Emulation for disks. If your template does **NOT** have SSD Emulation enabled as the default, the Proxmox provider **will** crash. To prevent accidental crashes, said feature was removed from this module.

[Back to Table of content](#table-of-content)