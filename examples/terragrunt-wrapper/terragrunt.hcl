terraform {
  source = "../..//wrappers"
}

/*
  UPDATE THESE VARIABLES TO MATCH YOUR ENVIRONMENT
*/
locals {
  vm1_target_node = "pve1"
  vm2_target_node = "pve2"

  # The name of the Virtual Machine clone
  vm1_clone = "ubuntu2204"
  vm2_clone = "ubuntu2204"

  # Locations to store said VM
  vm1_storage_location = "local-pve"
  vm2_storage_location = "local-pve"
}

inputs = {

  /*
    The arguments inside 'defaults' will be passed to 'vm-one' and 'vm-two'

    You can override any of these variables in 'vm-one' and 'vm-two' if needed.
  */
  defaults = {
    create_vm = true

    memory = 1024

    networks = [{
      dhcp   = true
      bridge = "vmbr0"
    }]

    tags = ["dev"]
  }

  items = {
    /*
      Virtual Machine #1 Configuration
    */
    vm-one = {
      clone       = local.vm1_clone
      target_node = local.vm1_target_node

      vm_name = "terragrunt-vm-1"

      disks = [{
        storage = local.vm1_storage_location
        size    = "10G"
        type    = "virtio"
      }]
      # Any additional VM specific arguments
    }

    /*
      Virtual Machine #2 Configuration
    */
    vm-two = {
      create_vm = true
      vm_name   = "terragrunt-vm-2"

      clone       = local.vm2_clone
      target_node = local.vm2_target_node

      disks = [{
        storage = local.vm2_storage_location
        size    = "10G"
        type    = "virtio"
      }]
      # Any additional VM specific arguments
    }
  }
}


/*
  Terragrunt Configurations
*/
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}

generate "main_providers" {
  path      = "main_providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "proxmox" {
}
EOF
}
