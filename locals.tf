# Local variables only accessible to this module
locals {
  # This allows us to use 'Count' with Terragrunt
  create_vm = var.create_vm

  # This converts the ipconfig object into a string that Proxmox can understand
  # Example 1: "gw=192.168.1.1,gw6=2001:0db8:85a3:0000:0000:8a2e:0370:7334,ip=192.168.1.100/24,ip6=2001:0db8:85a3:0000:0000:8a2e:0370:7334/64"
  # Example 2: "ip=dhcp"
  # Example 3: "gw=192.168.1.1,ip=192.168.1.100/24"
  ipconfig0 = length(var.networks) >= 1 ? try(join(",", compact([

    # If dhcp is true, return ""
    # If gateway matches regex, return "gw:Address"
    # If gateway does not meet regex, return ""
    var.networks[0].dhcp ? "" : var.networks[0].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[0].gateway))
    ? "gw=${var.networks[0].gateway}" : "",

    # If dhcp6 is true, return ""
    # If gateway6 matches regex, return "gw6:Address"
    # If gateway6 does not meet regex, return ""
    var.networks[0].dhcp6 ? "" : var.networks[0].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[0].gateway6))
    ? "gw6=${var.networks[0].gateway6}" : "",

    # If dhcp is true, return "ip=dhcp"
    # If ip matches regex, return "ip:Address"
    # If ip does not meet regex, return ""
    var.networks[0].dhcp ? "ip=dhcp" : var.networks[0].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[0].ip))
    ? "ip=${var.networks[0].ip}" : "",

    # If dhcp6 is true, return "ip6=dhcp"
    # If ip6 matches regex, return "ip6:Address"
    # If ip6 does not meet regex, return ""
    var.networks[0].dhcp6 ? "ip6=dhcp" : var.networks[0].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[0].ip6))
    ? "ip6=${var.networks[0].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig1 = length(var.networks) >= 2 ? try(join(",", compact([
    var.networks[1].dhcp ? "" : var.networks[1].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[1].gateway))
    ? "gw=${var.networks[1].gateway}" : "",

    var.networks[1].dhcp6 ? "" : var.networks[1].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[1].gateway6))
    ? "gw6=${var.networks[1].gateway6}" : "",

    var.networks[1].dhcp ? "ip=dhcp" : var.networks[1].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[1].ip))
    ? "ip=${var.networks[1].ip}" : "",

    var.networks[1].dhcp6 ? "ip6=dhcp" : var.networks[1].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[1].ip6))
    ? "ip6=${var.networks[1].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig2 = length(var.networks) >= 3 ? try(join(",", compact([
    var.networks[2].dhcp ? "" : var.networks[2].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[2].gateway))
    ? "gw=${var.networks[2].gateway}" : "",

    var.networks[2].dhcp6 ? "" : var.networks[2].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[2].gateway6))
    ? "gw6=${var.networks[2].gateway6}" : "",

    var.networks[2].dhcp ? "ip=dhcp" : var.networks[2].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[2].ip))
    ? "ip=${var.networks[2].ip}" : "",

    var.networks[2].dhcp6 ? "ip6=dhcp" : var.networks[2].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[2].ip6))
    ? "ip6=${var.networks[2].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig3 = length(var.networks) >= 4 ? try(join(",", compact([
    var.networks[3].dhcp ? "" : var.networks[3].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[3].gateway))
    ? "gw=${var.networks[3].gateway}" : "",

    var.networks[3].dhcp6 ? "" : var.networks[3].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[3].gateway6))
    ? "gw6=${var.networks[3].gateway6}" : "",

    var.networks[3].dhcp ? "ip=dhcp" : var.networks[3].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[3].ip))
    ? "ip=${var.networks[3].ip}" : "",

    var.networks[3].dhcp6 ? "ip6=dhcp" : var.networks[3].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[3].ip6))
    ? "ip6=${var.networks[3].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig4 = length(var.networks) >= 5 ? try(join(",", compact([
    var.networks[4].dhcp ? "" : var.networks[4].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[4].gateway))
    ? "gw=${var.networks[4].gateway}" : "",

    var.networks[4].dhcp6 ? "" : var.networks[4].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[4].gateway6))
    ? "gw6=${var.networks[4].gateway6}" : "",

    var.networks[4].dhcp ? "ip=dhcp" : var.networks[4].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[4].ip))
    ? "ip=${var.networks[4].ip}" : "",

    var.networks[4].dhcp6 ? "ip6=dhcp" : var.networks[4].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[4].ip6))
    ? "ip6=${var.networks[4].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig5 = length(var.networks) >= 6 ? try(join(",", compact([
    var.networks[5].dhcp ? "" : var.networks[5].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[5].gateway))
    ? "gw=${var.networks[5].gateway}" : "",

    var.networks[5].dhcp6 ? "" : var.networks[5].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[5].gateway6))
    ? "gw6=${var.networks[5].gateway6}" : "",

    var.networks[5].dhcp ? "ip=dhcp" : var.networks[5].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[5].ip))
    ? "ip=${var.networks[5].ip}" : "",

    var.networks[5].dhcp6 ? "ip6=dhcp" : var.networks[5].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[5].ip6))
    ? "ip6=${var.networks[5].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig6 = length(var.networks) >= 7 ? try(join(",", compact([
    var.networks[6].dhcp ? "" : var.networks[6].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[6].gateway))
    ? "gw=${var.networks[6].gateway}" : "",

    var.networks[6].dhcp6 ? "" : var.networks[6].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[6].gateway6))
    ? "gw6=${var.networks[6].gateway6}" : "",

    var.networks[6].dhcp ? "ip=dhcp" : var.networks[6].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[6].ip))
    ? "ip=${var.networks[6].ip}" : "",

    var.networks[6].dhcp6 ? "ip6=dhcp" : var.networks[6].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[6].ip6))
    ? "ip6=${var.networks[6].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig7 = length(var.networks) >= 8 ? try(join(",", compact([
    var.networks[7].dhcp ? "" : var.networks[7].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[7].gateway))
    ? "gw=${var.networks[7].gateway}" : "",

    var.networks[7].dhcp6 ? "" : var.networks[7].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[7].gateway6))
    ? "gw6=${var.networks[7].gateway6}" : "",

    var.networks[7].dhcp ? "ip=dhcp" : var.networks[7].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[7].ip))
    ? "ip=${var.networks[7].ip}" : "",

    var.networks[7].dhcp6 ? "ip6=dhcp" : var.networks[7].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[7].ip6))
    ? "ip6=${var.networks[7].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig8 = length(var.networks) >= 9 ? try(join(",", compact([
    var.networks[8].dhcp ? "" : var.networks[8].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[8].gateway))
    ? "gw=${var.networks[8].gateway}" : "",

    var.networks[8].dhcp6 ? "" : var.networks[8].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[8].gateway6))
    ? "gw6=${var.networks[8].gateway6}" : "",

    var.networks[8].dhcp ? "ip=dhcp" : var.networks[8].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[8].ip))
    ? "ip=${var.networks[8].ip}" : "",

    var.networks[8].dhcp6 ? "ip6=dhcp" : var.networks[8].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[8].ip6))
    ? "ip6=${var.networks[8].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig9 = try(join(",", compact([

    var.ipconfig9.dhcp ? "" : var.ipconfig9.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig9.gateway))
    ? "gw=${var.ipconfig9.gateway}" : "",

    var.ipconfig9.dhcp6 ? "" : var.ipconfig9.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig9.gateway6))
    ? "gw6=${var.ipconfig9.gateway6}" : "",

    var.ipconfig9.dhcp ? "ip=dhcp" : var.ipconfig9.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig9.ip))
    ? "ip=${var.ipconfig9.ip}" : "",

    var.ipconfig9.dhcp6 ? "ip6=dhcp" : var.ipconfig9.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig9.ip6))
    ? "ip6=${var.ipconfig9.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig10 = try(join(",", compact([

    var.ipconfig10.dhcp ? "" : var.ipconfig10.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig10.gateway))
    ? "gw=${var.ipconfig10.gateway}" : "",

    var.ipconfig10.dhcp6 ? "" : var.ipconfig10.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig10.gateway6))
    ? "gw6=${var.ipconfig10.gateway6}" : "",

    var.ipconfig10.dhcp ? "ip=dhcp" : var.ipconfig10.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig10.ip))
    ? "ip=${var.ipconfig10.ip}" : "",

    var.ipconfig10.dhcp6 ? "ip6=dhcp" : var.ipconfig10.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig10.ip6))
    ? "ip6=${var.ipconfig10.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig11 = try(join(",", compact([

    var.ipconfig11.dhcp ? "" : var.ipconfig11.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig11.gateway))
    ? "gw=${var.ipconfig11.gateway}" : "",

    var.ipconfig11.dhcp6 ? "" : var.ipconfig11.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig11.gateway6))
    ? "gw6=${var.ipconfig11.gateway6}" : "",

    var.ipconfig11.dhcp ? "ip=dhcp" : var.ipconfig11.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig11.ip))
    ? "ip=${var.ipconfig11.ip}" : "",

    var.ipconfig11.dhcp6 ? "ip6=dhcp" : var.ipconfig11.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig11.ip6))
    ? "ip6=${var.ipconfig11.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig12 = try(join(",", compact([

    var.ipconfig12.dhcp ? "" : var.ipconfig12.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig12.gateway))
    ? "gw=${var.ipconfig12.gateway}" : "",

    var.ipconfig12.dhcp6 ? "" : var.ipconfig12.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig12.gateway6))
    ? "gw6=${var.ipconfig12.gateway6}" : "",

    var.ipconfig12.dhcp ? "ip=dhcp" : var.ipconfig12.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig12.ip))
    ? "ip=${var.ipconfig12.ip}" : "",

    var.ipconfig12.dhcp6 ? "ip6=dhcp" : var.ipconfig12.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig12.ip6))
    ? "ip6=${var.ipconfig12.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig13 = try(join(",", compact([

    var.ipconfig13.dhcp ? "" : var.ipconfig13.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig13.gateway))
    ? "gw=${var.ipconfig13.gateway}" : "",

    var.ipconfig13.dhcp6 ? "" : var.ipconfig13.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig13.gateway6))
    ? "gw6=${var.ipconfig13.gateway6}" : "",

    var.ipconfig13.dhcp ? "ip=dhcp" : var.ipconfig13.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig13.ip))
    ? "ip=${var.ipconfig13.ip}" : "",

    var.ipconfig13.dhcp6 ? "ip6=dhcp" : var.ipconfig13.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig13.ip6))
    ? "ip6=${var.ipconfig13.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig14 = try(join(",", compact([

    var.ipconfig14.dhcp ? "" : var.ipconfig14.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig14.gateway))
    ? "gw=${var.ipconfig14.gateway}" : "",

    var.ipconfig14.dhcp6 ? "" : var.ipconfig14.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig14.gateway6))
    ? "gw6=${var.ipconfig14.gateway6}" : "",

    var.ipconfig14.dhcp ? "ip=dhcp" : var.ipconfig14.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig14.ip))
    ? "ip=${var.ipconfig14.ip}" : "",

    var.ipconfig14.dhcp6 ? "ip6=dhcp" : var.ipconfig14.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig14.ip6))
    ? "ip6=${var.ipconfig14.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig15 = try(join(",", compact([

    var.ipconfig15.dhcp ? "" : var.ipconfig15.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig15.gateway))
    ? "gw=${var.ipconfig15.gateway}" : "",

    var.ipconfig15.dhcp6 ? "" : var.ipconfig15.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig15.gateway6))
    ? "gw6=${var.ipconfig15.gateway6}" : "",

    var.ipconfig15.dhcp ? "ip=dhcp" : var.ipconfig15.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig15.ip))
    ? "ip=${var.ipconfig15.ip}" : "",

    var.ipconfig15.dhcp6 ? "ip6=dhcp" : var.ipconfig15.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig15.ip6))
    ? "ip6=${var.ipconfig15.ip6}" : ""
  ])), null)
}
