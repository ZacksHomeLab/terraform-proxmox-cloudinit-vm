provider "proxmox" {
  #pm_tls_insecure = true
}

module "cloudinit_vm" {
  source = "../../"

  automatic_reboot            = local.automatic_reboot
  cipassword                  = local.cipassword
  ciuser                      = local.ciuser
  clone                       = local.clone
  cores                       = local.cores
  cpu                         = local.cpu
  create_vm                   = local.create_vm
  description                 = local.description
  disks                       = local.disks
  force_create                = local.force_create
  force_recreate_on_change_of = local.force_recreate_on_change_of
  hagroup                     = local.hagroup
  hastate                     = local.hastate
  hotplug                     = local.hotplug
  memory                      = local.memory
  nameserver                  = local.nameserver
  networks                    = local.networks
  numa                        = local.numa
  onboot                      = local.onboot
  oncreate                    = local.oncreate
  pool                        = local.pool
  scsihw                      = local.scsihw
  searchdomain                = local.searchdomain
  sockets                     = local.sockets
  sshkeys                     = local.sshkeys
  tags                        = local.tags
  target_node                 = local.target_node
  vm_name                     = local.vm_name
  vmid                        = local.vmid
}
