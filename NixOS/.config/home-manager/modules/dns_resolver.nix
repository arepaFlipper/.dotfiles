{ config, pkgs, lib, ... }:

{
  # Add host aliases via the hosts file
  home.file."/etc/hosts".text = lib.concatStringsSep "\n"
    [
      "# Added by Home-Manager hosts.nix"
      "127.0.0.1    localhost"
      "192.168.1.88    m2"
    ];
}

