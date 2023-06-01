locals {

  # Automatically reboot the VM when parameter changes require this. If disabled the provider will emit a warning when the VM needs to be rebooted.
  automatic_reboot = true

  # Override the default cloud-init user's password. Sensitive.
  cipassword = "my_password"

  # Override the default cloud-init user for provisioning.
  ciuser = "my_username"

  # The base VM from which to clone to create the new VM. Note that clone is mutually exclussive with pxe and iso modes.
  clone = var.clone

  # The number of CPU cores per CPU socket to allocate to the VM.
  cores = 1

  # The type of CPU to emulate in the Guest. See the docs about CPU Types for more info. ('host' allows you to virtualize on said VM)
  cpu = "host"

  # Controls if virtual machine should be created.
  create_vm = true

  # The description of the VM. Shows as the 'Notes' field in the Proxmox GUI.
  description = "Virtual Machine's description"

  /*
    Disk Configuration

      type               - The type of disk device to add. Options: ide, sata, scsi, virtio.
      storage            - The name of the storage pool on which to store the disk.
      size               - The size of the created disk, format must match the regex \d+[GMK], where G, M, and K represent Gigabytes, Megabytes, and Kilobytes respectively.
      format             - The drive’s backing file’s data format.
      cache              - The drive’s cache mode. Options: directsync, none, unsafe, writeback, writethrough
      backup             - Whether the drive should be included when making backups.
      iothread           - Whether to use iothreads for this drive. Only effective with a disk of type virtio, or scsi when the the emulated controller type (scsihw top level block argument) is virtio-scsi-single.
      replicate          - Whether the drive should considered for replication jobs.
      discard            - Controls whether to pass discard/trim requests to the underlying storage. Only effective when the underlying storage supports thin provisioning. 
      mbps               - Maximum r/w speed in megabytes per second. 0 means unlimited.
      mbps_rd            - Maximum read speed in megabytes per second. 0 means unlimited.
      mbps_rd_max        - Maximum read speed in megabytes per second. 0 means unlimited.
      mbps_wr            - Maximum write speed in megabytes per second. 0 means unlimited.
      mbps_wr_max        - Maximum throttled write pool in megabytes per second. 0 means unlimited.
      media              - The drive’s media type. Options: cdrom, disk.
      iops               - Maximum r/w I/O in operations per second.
      iops_rd            - Maximum read I/O in operations per second.
      iops_rd_max        - Maximum unthrottled read I/O pool in operations per second.
      iops_rd_max_length - Maximum length of read I/O bursts in seconds.
      iops_wr            - Maximum write I/O in operations per second.
      iops_wr_max        - Maximum unthrottled write I/O pool in operations per second.
      iops_wr_max_length - Maximum length of write I/O bursts in seconds.
    
  */
  disks = [
    {
      type               = "virtio"
      storage            = var.storage_location
      size               = "10G"
      format             = "raw"
      cache              = "writeback"
      backup             = true
      iothread           = 0
      replicate          = 0
      discard            = 0
      mbps               = 0
      mbps_rd            = 0
      mbps_rd_max        = 0
      mbps_wr            = 0
      mbps_wr_max        = 0
      media              = "disk"
      iops               = 0
      iops_rd            = 0
      iops_rd_max        = 0
      iops_rd_max_length = 0
      iops_wr            = 0
      iops_wr_max        = 0
      iops_wr_max_length = 0
    }
  ]

  # If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with these settings. 
  # Set to true to always create a new VM (note, the name of the VM must still be unique, otherwise an error will be produced.).
  force_create = false
  /*
    If the value of this string changes, the VM will be recreated. Useful for allowing this resource to be recreated when arbitrary attributes change. 
    An example where this is useful is a cloudinit configuration (as the cicustom attribute points to a file not the content).

    force_recreate_on_change_of = data.template_file.cicustom.rendered
  */
  force_recreate_on_change_of = ""

  /*
    hagroup - The HA group identifier the resource belongs to (requires hastate to be set!).
    hastate - Requested HA state for the resource. One of 'started', 'stopped', 'enabled', 'disabled', or 'ignored'. See the docs about HA for more info.

    hagroup = "my_resource_group"
    hastate = enabled
  */
  hagroup = ""
  hastate = ""

  /*
    Comma delimited list of hotplug features to enable. Options: network, disk, cpu, memory, usb. Set to 0 to disable hotplug.

    To add memory into hotplug, you would set the variable to:
    hotplug = "cpu,memory,network,disk,usb"
  */
  hotplug = "cpu,network,disk,usb"

  # The amount of memory to allocate to the VM in Megabytes.
  memory = 2048

  # Sets default DNS server for guest.
  nameserver = "example.com"

  /*
    Network Adapter Configurations

      bridge    - Bridge to which the network device should be attached. The Proxmox VE standard bridge is called vmbr0.
      model     - Network Card Model. The virtio model provides the best performance with very low CPU overhead. If your VM does not support it, next best option is e1000
      gateway   - The IPv4 Gateway of the Virtual Machine. Does NOT need to be in CIDR-notation (e.g., this will work: 192.168.1.1)
      gateway6  - The IPv6 Gateway of the Virtual Machine. Does NOT need to be in CIDR-notation.
      ip        - The IPv4 Address of the Virtual Machine. MUST be in CIDR-notation (e.g., 192.168.1.123/24)
      ip6       - The IPv6 Address of the Virtual Machine. MUST be in CIDR-notation.
      dhcp      - Set dhcp to true to enable dhcp for IPv4 Addresses. This will override static IP assignments.
      dhcp6     - Set dhcp6 to true to enable dhcp for IPv6 Addresses. This will override static IP assignments.
      firewall  - Whether to enable the Proxmox firewall on this network device.
      link_down - Whether this interface should be disconnected (like pulling the plug).
      macaddr   - Override the randomly generated MAC Address for the VM. Requires the MAC Address be Unicast.
      queues    - Number of packet queues to be used on the device. Requires virtio model to have an effect.
      rate      - Network device rate limit in mbps (megabytes per second) as floating point number. Set to 0 to disable rate limiting.
      vlan_tag  - The VLAN tag to apply to packets on this device. -1 disables VLAN tagging.
  */
  networks = [{
    bridge    = "vmbr0"
    model     = "virtio"
    gateway   = ""
    gateway6  = ""
    ip        = ""
    ip6       = ""
    dhcp      = true
    dhcp6     = false
    firewall  = true
    link_down = false
    #macaddr   = "" # Commented-out as this will generate an error if you do not provide an address.
    queues   = 1
    rate     = 0
    vlan_tag = -1
  }]

  # Whether to enable Non-Uniform Memory Access in the guest. Must have 'memory' in hotplug. 
  numa = false

  # Whether to have the VM startup after the PVE node starts.
  onboot = true

  # Whether to have the VM startup after the VM is created.
  oncreate = true

  # The resource pool to which the VM will be added.
  pool = ""

  # The SCSI controller to emulate. Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single.
  scsihw = "virtio-scsi-pci"

  # Sets default DNS search domain suffix.
  searchdomain = "example_domain.com"

  # The number of CPU sockets for the Master Node.
  sockets = 1

  /*
    Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user

    Example (omitted most of the key to save space):

    sshkeys      = <<EOF
ssh-rsa AAAAB3NzaC1yc2YcS+LkeTl9JaW/XzZrzGpb5kQhBNXoSXQ== zackshomelab\zack@ZHLDT01
EOF
  */
  sshkeys = ""

  # Tags of the VM. This is only meta information.
  tags = ["tag1", "tag2", "tag3"]


  # The name of the Proxmox Node on which to place the VM.
  target_node = var.target_node

  # The virtual machine name.
  vm_name = "vm-name-example"

  # The ID of the VM in Proxmox. 
  # The default value of 0 indicates it should use the next available ID in the sequence.
  vmid = 0
}
