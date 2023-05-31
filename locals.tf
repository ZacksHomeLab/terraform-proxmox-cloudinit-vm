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
  ipconfig9 = length(var.networks) >= 10 ? try(join(",", compact([
    var.networks[9].dhcp ? "" : var.networks[9].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[9].gateway))
    ? "gw=${var.networks[9].gateway}" : "",

    var.networks[9].dhcp6 ? "" : var.networks[9].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[9].gateway6))
    ? "gw6=${var.networks[9].gateway6}" : "",

    var.networks[9].dhcp ? "ip=dhcp" : var.networks[9].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[9].ip))
    ? "ip=${var.networks[9].ip}" : "",

    var.networks[9].dhcp6 ? "ip6=dhcp" : var.networks[9].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[9].ip6))
    ? "ip6=${var.networks[9].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig10 = length(var.networks) >= 11 ? try(join(",", compact([
    var.networks[10].dhcp ? "" : var.networks[10].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[10].gateway))
    ? "gw=${var.networks[10].gateway}" : "",

    var.networks[10].dhcp6 ? "" : var.networks[10].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[10].gateway6))
    ? "gw6=${var.networks[10].gateway6}" : "",

    var.networks[10].dhcp ? "ip=dhcp" : var.networks[10].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[10].ip))
    ? "ip=${var.networks[10].ip}" : "",

    var.networks[10].dhcp6 ? "ip6=dhcp" : var.networks[10].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[10].ip6))
    ? "ip6=${var.networks[10].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig11 = length(var.networks) >= 12 ? try(join(",", compact([
    var.networks[11].dhcp ? "" : var.networks[11].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[11].gateway))
    ? "gw=${var.networks[11].gateway}" : "",

    var.networks[11].dhcp6 ? "" : var.networks[11].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[11].gateway6))
    ? "gw6=${var.networks[11].gateway6}" : "",

    var.networks[11].dhcp ? "ip=dhcp" : var.networks[11].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[11].ip))
    ? "ip=${var.networks[11].ip}" : "",

    var.networks[11].dhcp6 ? "ip6=dhcp" : var.networks[11].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[11].ip6))
    ? "ip6=${var.networks[11].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig12 = length(var.networks) >= 13 ? try(join(",", compact([
    var.networks[12].dhcp ? "" : var.networks[12].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[12].gateway))
    ? "gw=${var.networks[12].gateway}" : "",

    var.networks[12].dhcp6 ? "" : var.networks[12].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[12].gateway6))
    ? "gw6=${var.networks[12].gateway6}" : "",

    var.networks[12].dhcp ? "ip=dhcp" : var.networks[12].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[12].ip))
    ? "ip=${var.networks[12].ip}" : "",

    var.networks[12].dhcp6 ? "ip6=dhcp" : var.networks[12].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[12].ip6))
    ? "ip6=${var.networks[12].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig13 = length(var.networks) >= 14 ? try(join(",", compact([
    var.networks[13].dhcp ? "" : var.networks[13].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[13].gateway))
    ? "gw=${var.networks[13].gateway}" : "",

    var.networks[13].dhcp6 ? "" : var.networks[13].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[13].gateway6))
    ? "gw6=${var.networks[13].gateway6}" : "",

    var.networks[13].dhcp ? "ip=dhcp" : var.networks[13].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[13].ip))
    ? "ip=${var.networks[13].ip}" : "",

    var.networks[13].dhcp6 ? "ip6=dhcp" : var.networks[13].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[13].ip6))
    ? "ip6=${var.networks[13].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig14 = length(var.networks) >= 15 ? try(join(",", compact([
    var.networks[14].dhcp ? "" : var.networks[14].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[14].gateway))
    ? "gw=${var.networks[14].gateway}" : "",

    var.networks[14].dhcp6 ? "" : var.networks[14].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[14].gateway6))
    ? "gw6=${var.networks[14].gateway6}" : "",

    var.networks[14].dhcp ? "ip=dhcp" : var.networks[14].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[14].ip))
    ? "ip=${var.networks[14].ip}" : "",

    var.networks[14].dhcp6 ? "ip6=dhcp" : var.networks[14].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[14].ip6))
    ? "ip6=${var.networks[14].ip6}" : ""
  ])), null) : null

  # See comments above ipconfig0
  ipconfig15 = length(var.networks) == 16 ? try(join(",", compact([
    var.networks[15].dhcp ? "" : var.networks[15].gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.networks[15].gateway))
    ? "gw=${var.networks[15].gateway}" : "",

    var.networks[15].dhcp6 ? "" : var.networks[15].gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.networks[15].gateway6))
    ? "gw6=${var.networks[15].gateway6}" : "",

    var.networks[15].dhcp ? "ip=dhcp" : var.networks[15].ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.networks[15].ip))
    ? "ip=${var.networks[15].ip}" : "",

    var.networks[15].dhcp6 ? "ip6=dhcp" : var.networks[15].ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.networks[15].ip6))
    ? "ip6=${var.networks[15].ip6}" : ""
  ])), null) : null
}
