# Local variables only accessible to this module
locals {
  # This allows us to use 'Count' with Terragrunt
  create_vm = var.create_vm

  # This converts the ipconfig object into a string that Proxmox can understand
  # Example 1: "gw=192.168.1.1,gw6=2001:0db8:85a3:0000:0000:8a2e:0370:7334,ip=192.168.1.100/24,ip6=2001:0db8:85a3:0000:0000:8a2e:0370:7334/64"
  # Example 2: "ip=dhcp"
  # Example 3: "gw=192.168.1.1,ip=192.168.1.100/24"
  ipconfig0 = try(join(",", compact([
    # If dhcp is true, return ""
    # If gateway matches regex, return "gw:Address"
    # If gateway does not meet regex, return ""
    var.ipconfig0.dhcp ? "" : var.ipconfig0.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig0.gateway))
    ? "gw=${var.ipconfig0.gateway}" : "",

    # If dhcp6 is true, return ""
    # If gateway6 matches regex, return "gw6:Address"
    # If gateway6 does not meet regex, return ""
    var.ipconfig0.dhcp6 ? "" : var.ipconfig0.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig0.gateway6))
    ? "gw6=${var.ipconfig0.gateway6}" : "",

    # If dhcp is true, return "ip=dhcp"
    # If ip matches regex, return "ip:Address"
    # If ip does not meet regex, return ""
    var.ipconfig0.dhcp ? "ip=dhcp" : var.ipconfig0.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig0.ip))
    ? "ip=${var.ipconfig0.ip}" : "",

    # If dhcp6 is true, return "ip6=dhcp"
    # If ip6 matches regex, return "ip6:Address"
    # If ip6 does not meet regex, return ""
    var.ipconfig0.dhcp6 ? "ip6=dhcp" : var.ipconfig0.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig0.ip6))
    ? "ip6=${var.ipconfig0.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig1 = try(join(",", compact([

    var.ipconfig1.dhcp ? "" : var.ipconfig1.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig1.gateway))
    ? "gw=${var.ipconfig1.gateway}" : "",

    var.ipconfig1.dhcp6 ? "" : var.ipconfig1.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig1.gateway6))
    ? "gw6=${var.ipconfig1.gateway6}" : "",

    var.ipconfig1.dhcp ? "ip=dhcp" : var.ipconfig1.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig1.ip))
    ? "ip=${var.ipconfig1.ip}" : "",

    var.ipconfig1.dhcp6 ? "ip6=dhcp" : var.ipconfig1.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig1.ip6))
    ? "ip6=${var.ipconfig1.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig2 = try(join(",", compact([

    var.ipconfig2.dhcp ? "" : var.ipconfig2.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig2.gateway))
    ? "gw=${var.ipconfig2.gateway}" : "",

    var.ipconfig2.dhcp6 ? "" : var.ipconfig2.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig2.gateway6))
    ? "gw6=${var.ipconfig2.gateway6}" : "",

    var.ipconfig2.dhcp ? "ip=dhcp" : var.ipconfig2.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig2.ip))
    ? "ip=${var.ipconfig2.ip}" : "",

    var.ipconfig2.dhcp6 ? "ip6=dhcp" : var.ipconfig2.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig2.ip6))
    ? "ip6=${var.ipconfig2.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig3 = try(join(",", compact([

    var.ipconfig3.dhcp ? "" : var.ipconfig3.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig3.gateway))
    ? "gw=${var.ipconfig3.gateway}" : "",

    var.ipconfig3.dhcp6 ? "" : var.ipconfig3.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig3.gateway6))
    ? "gw6=${var.ipconfig3.gateway6}" : "",

    var.ipconfig3.dhcp ? "ip=dhcp" : var.ipconfig3.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig3.ip))
    ? "ip=${var.ipconfig3.ip}" : "",

    var.ipconfig3.dhcp6 ? "ip6=dhcp" : var.ipconfig3.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig3.ip6))
    ? "ip6=${var.ipconfig3.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig4 = try(join(",", compact([

    var.ipconfig4.dhcp ? "" : var.ipconfig4.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig4.gateway))
    ? "gw=${var.ipconfig4.gateway}" : "",

    var.ipconfig4.dhcp6 ? "" : var.ipconfig4.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig4.gateway6))
    ? "gw6=${var.ipconfig4.gateway6}" : "",

    var.ipconfig4.dhcp ? "ip=dhcp" : var.ipconfig4.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig4.ip))
    ? "ip=${var.ipconfig4.ip}" : "",

    var.ipconfig4.dhcp6 ? "ip6=dhcp" : var.ipconfig4.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig4.ip6))
    ? "ip6=${var.ipconfig4.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig5 = try(join(",", compact([

    var.ipconfig5.dhcp ? "" : var.ipconfig5.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig5.gateway))
    ? "gw=${var.ipconfig5.gateway}" : "",

    var.ipconfig5.dhcp6 ? "" : var.ipconfig5.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig5.gateway6))
    ? "gw6=${var.ipconfig5.gateway6}" : "",

    var.ipconfig5.dhcp ? "ip=dhcp" : var.ipconfig5.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig5.ip))
    ? "ip=${var.ipconfig5.ip}" : "",

    var.ipconfig5.dhcp6 ? "ip6=dhcp" : var.ipconfig5.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig5.ip6))
    ? "ip6=${var.ipconfig5.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig6 = try(join(",", compact([

    var.ipconfig6.dhcp ? "" : var.ipconfig6.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig6.gateway))
    ? "gw=${var.ipconfig6.gateway}" : "",

    var.ipconfig6.dhcp6 ? "" : var.ipconfig6.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig6.gateway6))
    ? "gw6=${var.ipconfig6.gateway6}" : "",

    var.ipconfig6.dhcp ? "ip=dhcp" : var.ipconfig6.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig6.ip))
    ? "ip=${var.ipconfig6.ip}" : "",

    var.ipconfig6.dhcp6 ? "ip6=dhcp" : var.ipconfig6.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig6.ip6))
    ? "ip6=${var.ipconfig6.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig7 = try(join(",", compact([

    var.ipconfig7.dhcp ? "" : var.ipconfig7.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig7.gateway))
    ? "gw=${var.ipconfig7.gateway}" : "",

    var.ipconfig7.dhcp6 ? "" : var.ipconfig7.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig7.gateway6))
    ? "gw6=${var.ipconfig7.gateway6}" : "",

    var.ipconfig7.dhcp ? "ip=dhcp" : var.ipconfig7.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig7.ip))
    ? "ip=${var.ipconfig7.ip}" : "",

    var.ipconfig7.dhcp6 ? "ip6=dhcp" : var.ipconfig7.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig7.ip6))
    ? "ip6=${var.ipconfig7.ip6}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig8 = try(join(",", compact([

    var.ipconfig8.dhcp ? "" : var.ipconfig8.gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig8.gateway))
    ? "gw=${var.ipconfig8.gateway}" : "",

    var.ipconfig8.dhcp6 ? "" : var.ipconfig8.gateway6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig8.gateway6))
    ? "gw6=${var.ipconfig8.gateway6}" : "",

    var.ipconfig8.dhcp ? "ip=dhcp" : var.ipconfig8.ip != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig8.ip))
    ? "ip=${var.ipconfig8.ip}" : "",

    var.ipconfig8.dhcp6 ? "ip6=dhcp" : var.ipconfig8.ip6 != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig8.ip6))
    ? "ip6=${var.ipconfig8.ip6}" : ""
  ])), null)

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
