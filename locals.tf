# Local variables only accessible to this module
locals {
  # This allows us to use 'Count' with Terragrunt
  create_vm = var.create_vm

  # This converts the ipconfig object into a string that Proxmox can understand
  # Example 1: "gw=192.168.1.1,gw6=2001:0db8:85a3:0000:0000:8a2e:0370:7334,ip=192.168.1.100/24,ip6=2001:0db8:85a3:0000:0000:8a2e:0370:7334/64"
  # Example 2: "ip=dhcp"
  # Example 3: "gw=192.168.1.1,ip=192.168.1.100/24"
  ipconfig0 = try(join(",", compact([
    # If DHCP is true, return ""
    # If IPv4Gateway matches regex, return "gw:Address"
    # If IPv4Gateway does not meet regex, return ""
    var.ipconfig0.DHCP ? "" : var.ipconfig0.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig0.IPv4Gateway))
    ? "gw=${var.ipconfig0.IPv4Gateway}" : "",

    # If DHCP6 is true, return ""
    # If IPv6Gateway matches regex, return "gw6:Address"
    # If IPv6Gateway does not meet regex, return ""
    var.ipconfig0.DHCP6 ? "" : var.ipconfig0.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig0.IPv6Gateway))
    ? "gw6=${var.ipconfig0.IPv6Gateway}" : "",

    # If DHCP is true, return "ip=dhcp"
    # If IPv4Address matches regex, return "ip:Address"
    # If IPv4Address does not meet regex, return ""
    var.ipconfig0.DHCP ? "ip=dhcp" : var.ipconfig0.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig0.IPv4Address))
    ? "ip=${var.ipconfig0.IPv4Address}" : "",

    # If DHCP6 is true, return "ip6=dhcp"
    # If IPv6Address matches regex, return "ip6:Address"
    # If IPv6Address does not meet regex, return ""
    var.ipconfig0.DHCP6 ? "ip6=dhcp" : var.ipconfig0.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig0.IPv6Address))
    ? "ip6=${var.ipconfig0.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig1 = try(join(",", compact([

    var.ipconfig1.DHCP ? "" : var.ipconfig1.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig1.IPv4Gateway))
    ? "gw=${var.ipconfig1.IPv4Gateway}" : "",

    var.ipconfig1.DHCP6 ? "" : var.ipconfig1.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig1.IPv6Gateway))
    ? "gw6=${var.ipconfig1.IPv6Gateway}" : "",

    var.ipconfig1.DHCP ? "ip=dhcp" : var.ipconfig1.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig1.IPv4Address))
    ? "ip=${var.ipconfig1.IPv4Address}" : "",

    var.ipconfig1.DHCP6 ? "ip6=dhcp" : var.ipconfig1.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig1.IPv6Address))
    ? "ip6=${var.ipconfig1.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig2 = try(join(",", compact([

    var.ipconfig2.DHCP ? "" : var.ipconfig2.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig2.IPv4Gateway))
    ? "gw=${var.ipconfig2.IPv4Gateway}" : "",

    var.ipconfig2.DHCP6 ? "" : var.ipconfig2.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig2.IPv6Gateway))
    ? "gw6=${var.ipconfig2.IPv6Gateway}" : "",

    var.ipconfig2.DHCP ? "ip=dhcp" : var.ipconfig2.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig2.IPv4Address))
    ? "ip=${var.ipconfig2.IPv4Address}" : "",

    var.ipconfig2.DHCP6 ? "ip6=dhcp" : var.ipconfig2.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig2.IPv6Address))
    ? "ip6=${var.ipconfig2.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig3 = try(join(",", compact([

    var.ipconfig3.DHCP ? "" : var.ipconfig3.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig3.IPv4Gateway))
    ? "gw=${var.ipconfig3.IPv4Gateway}" : "",

    var.ipconfig3.DHCP6 ? "" : var.ipconfig3.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig3.IPv6Gateway))
    ? "gw6=${var.ipconfig3.IPv6Gateway}" : "",

    var.ipconfig3.DHCP ? "ip=dhcp" : var.ipconfig3.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig3.IPv4Address))
    ? "ip=${var.ipconfig3.IPv4Address}" : "",

    var.ipconfig3.DHCP6 ? "ip6=dhcp" : var.ipconfig3.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig3.IPv6Address))
    ? "ip6=${var.ipconfig3.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig4 = try(join(",", compact([

    var.ipconfig4.DHCP ? "" : var.ipconfig4.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig4.IPv4Gateway))
    ? "gw=${var.ipconfig4.IPv4Gateway}" : "",

    var.ipconfig4.DHCP6 ? "" : var.ipconfig4.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig4.IPv6Gateway))
    ? "gw6=${var.ipconfig4.IPv6Gateway}" : "",

    var.ipconfig4.DHCP ? "ip=dhcp" : var.ipconfig4.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig4.IPv4Address))
    ? "ip=${var.ipconfig4.IPv4Address}" : "",

    var.ipconfig4.DHCP6 ? "ip6=dhcp" : var.ipconfig4.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig4.IPv6Address))
    ? "ip6=${var.ipconfig4.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig5 = try(join(",", compact([

    var.ipconfig5.DHCP ? "" : var.ipconfig5.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig5.IPv4Gateway))
    ? "gw=${var.ipconfig5.IPv4Gateway}" : "",

    var.ipconfig5.DHCP6 ? "" : var.ipconfig5.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig5.IPv6Gateway))
    ? "gw6=${var.ipconfig5.IPv6Gateway}" : "",

    var.ipconfig5.DHCP ? "ip=dhcp" : var.ipconfig5.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig5.IPv4Address))
    ? "ip=${var.ipconfig5.IPv4Address}" : "",

    var.ipconfig5.DHCP6 ? "ip6=dhcp" : var.ipconfig5.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig5.IPv6Address))
    ? "ip6=${var.ipconfig5.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig6 = try(join(",", compact([

    var.ipconfig6.DHCP ? "" : var.ipconfig6.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig6.IPv4Gateway))
    ? "gw=${var.ipconfig6.IPv4Gateway}" : "",

    var.ipconfig6.DHCP6 ? "" : var.ipconfig6.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig6.IPv6Gateway))
    ? "gw6=${var.ipconfig6.IPv6Gateway}" : "",

    var.ipconfig6.DHCP ? "ip=dhcp" : var.ipconfig6.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig6.IPv4Address))
    ? "ip=${var.ipconfig6.IPv4Address}" : "",

    var.ipconfig6.DHCP6 ? "ip6=dhcp" : var.ipconfig6.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig6.IPv6Address))
    ? "ip6=${var.ipconfig6.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig7 = try(join(",", compact([

    var.ipconfig7.DHCP ? "" : var.ipconfig7.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig7.IPv4Gateway))
    ? "gw=${var.ipconfig7.IPv4Gateway}" : "",

    var.ipconfig7.DHCP6 ? "" : var.ipconfig7.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig7.IPv6Gateway))
    ? "gw6=${var.ipconfig7.IPv6Gateway}" : "",

    var.ipconfig7.DHCP ? "ip=dhcp" : var.ipconfig7.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig7.IPv4Address))
    ? "ip=${var.ipconfig7.IPv4Address}" : "",

    var.ipconfig7.DHCP6 ? "ip6=dhcp" : var.ipconfig7.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig7.IPv6Address))
    ? "ip6=${var.ipconfig7.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig8 = try(join(",", compact([

    var.ipconfig8.DHCP ? "" : var.ipconfig8.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig8.IPv4Gateway))
    ? "gw=${var.ipconfig8.IPv4Gateway}" : "",

    var.ipconfig8.DHCP6 ? "" : var.ipconfig8.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig8.IPv6Gateway))
    ? "gw6=${var.ipconfig8.IPv6Gateway}" : "",

    var.ipconfig8.DHCP ? "ip=dhcp" : var.ipconfig8.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig8.IPv4Address))
    ? "ip=${var.ipconfig8.IPv4Address}" : "",

    var.ipconfig8.DHCP6 ? "ip6=dhcp" : var.ipconfig8.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig8.IPv6Address))
    ? "ip6=${var.ipconfig8.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig9 = try(join(",", compact([

    var.ipconfig9.DHCP ? "" : var.ipconfig9.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig9.IPv4Gateway))
    ? "gw=${var.ipconfig9.IPv4Gateway}" : "",

    var.ipconfig9.DHCP6 ? "" : var.ipconfig9.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig9.IPv6Gateway))
    ? "gw6=${var.ipconfig9.IPv6Gateway}" : "",

    var.ipconfig9.DHCP ? "ip=dhcp" : var.ipconfig9.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig9.IPv4Address))
    ? "ip=${var.ipconfig9.IPv4Address}" : "",

    var.ipconfig9.DHCP6 ? "ip6=dhcp" : var.ipconfig9.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig9.IPv6Address))
    ? "ip6=${var.ipconfig9.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig10 = try(join(",", compact([

    var.ipconfig10.DHCP ? "" : var.ipconfig10.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig10.IPv4Gateway))
    ? "gw=${var.ipconfig10.IPv4Gateway}" : "",

    var.ipconfig10.DHCP6 ? "" : var.ipconfig10.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig10.IPv6Gateway))
    ? "gw6=${var.ipconfig10.IPv6Gateway}" : "",

    var.ipconfig10.DHCP ? "ip=dhcp" : var.ipconfig10.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig10.IPv4Address))
    ? "ip=${var.ipconfig10.IPv4Address}" : "",

    var.ipconfig10.DHCP6 ? "ip6=dhcp" : var.ipconfig10.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig10.IPv6Address))
    ? "ip6=${var.ipconfig10.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig11 = try(join(",", compact([

    var.ipconfig11.DHCP ? "" : var.ipconfig11.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig11.IPv4Gateway))
    ? "gw=${var.ipconfig11.IPv4Gateway}" : "",

    var.ipconfig11.DHCP6 ? "" : var.ipconfig11.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig11.IPv6Gateway))
    ? "gw6=${var.ipconfig11.IPv6Gateway}" : "",

    var.ipconfig11.DHCP ? "ip=dhcp" : var.ipconfig11.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig11.IPv4Address))
    ? "ip=${var.ipconfig11.IPv4Address}" : "",

    var.ipconfig11.DHCP6 ? "ip6=dhcp" : var.ipconfig11.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig11.IPv6Address))
    ? "ip6=${var.ipconfig11.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig12 = try(join(",", compact([

    var.ipconfig12.DHCP ? "" : var.ipconfig12.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig12.IPv4Gateway))
    ? "gw=${var.ipconfig12.IPv4Gateway}" : "",

    var.ipconfig12.DHCP6 ? "" : var.ipconfig12.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig12.IPv6Gateway))
    ? "gw6=${var.ipconfig12.IPv6Gateway}" : "",

    var.ipconfig12.DHCP ? "ip=dhcp" : var.ipconfig12.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig12.IPv4Address))
    ? "ip=${var.ipconfig12.IPv4Address}" : "",

    var.ipconfig12.DHCP6 ? "ip6=dhcp" : var.ipconfig12.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig12.IPv6Address))
    ? "ip6=${var.ipconfig12.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig13 = try(join(",", compact([

    var.ipconfig13.DHCP ? "" : var.ipconfig13.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig13.IPv4Gateway))
    ? "gw=${var.ipconfig13.IPv4Gateway}" : "",

    var.ipconfig13.DHCP6 ? "" : var.ipconfig13.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig13.IPv6Gateway))
    ? "gw6=${var.ipconfig13.IPv6Gateway}" : "",

    var.ipconfig13.DHCP ? "ip=dhcp" : var.ipconfig13.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig13.IPv4Address))
    ? "ip=${var.ipconfig13.IPv4Address}" : "",

    var.ipconfig13.DHCP6 ? "ip6=dhcp" : var.ipconfig13.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig13.IPv6Address))
    ? "ip6=${var.ipconfig13.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig14 = try(join(",", compact([

    var.ipconfig14.DHCP ? "" : var.ipconfig14.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig14.IPv4Gateway))
    ? "gw=${var.ipconfig14.IPv4Gateway}" : "",

    var.ipconfig14.DHCP6 ? "" : var.ipconfig14.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig14.IPv6Gateway))
    ? "gw6=${var.ipconfig14.IPv6Gateway}" : "",

    var.ipconfig14.DHCP ? "ip=dhcp" : var.ipconfig14.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig14.IPv4Address))
    ? "ip=${var.ipconfig14.IPv4Address}" : "",

    var.ipconfig14.DHCP6 ? "ip6=dhcp" : var.ipconfig14.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig14.IPv6Address))
    ? "ip6=${var.ipconfig14.IPv6Address}" : ""
  ])), null)

  # See comments above ipconfig0
  ipconfig15 = try(join(",", compact([

    var.ipconfig15.DHCP ? "" : var.ipconfig15.IPv4Gateway != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b$", var.ipconfig15.IPv4Gateway))
    ? "gw=${var.ipconfig15.IPv4Gateway}" : "",

    var.ipconfig15.DHCP6 ? "" : var.ipconfig15.IPv6Gateway != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.ipconfig15.IPv6Gateway))
    ? "gw6=${var.ipconfig15.IPv6Gateway}" : "",

    var.ipconfig15.DHCP ? "ip=dhcp" : var.ipconfig15.IPv4Address != null
    && can(regex("^\\b(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))\\b(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", var.ipconfig15.IPv4Address))
    ? "ip=${var.ipconfig15.IPv4Address}" : "",

    var.ipconfig15.DHCP6 ? "ip6=dhcp" : var.ipconfig15.IPv6Address != null
    && can(regex("^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\\/(?:[0-9]|[1-9]\\d|1[0-2][0-8])$", var.ipconfig15.IPv6Address))
    ? "ip6=${var.ipconfig15.IPv6Address}" : ""
  ])), null)
}
