{ config, pkgs, lib, ... }:
# Two-way sync of the intranet repo's Docs/ (an Obsidian vault) with the
# dedicated docs bucket gs://abexus-intranet-docs-1016397209780 (remote
# `gcs-docs`). See ~/Documents/ABEXUS/intranet/dev/Docs/OBSIDIAN.md §3 and §5.
let
  repo = "${config.home.homeDirectory}/Documents/ABEXUS/intranet/dev";
  # Off until the rclone remote exists and the first `docs-sync --resync` ran
  # (OBSIDIAN.md §5.2); before that every run would fail.
  startTimer = false;
in
{
  home.packages = with pkgs; [
    rclone
  ];

  systemd.user.services.docs-sync = {
    Unit = {
      Description = "Sync Docs vault with GCS";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      # User units get a bare PATH; the script needs bash, git and rclone
      Environment = [ "PATH=${lib.makeBinPath (with pkgs; [ bash coreutils git rclone ])}" ];
      ExecStart = "${repo}/scripts/docs-sync.sh -v";
    };
  };

  systemd.user.timers.docs-sync = {
    Unit.Description = "Sync Docs vault every 5 minutes";
    Timer = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
      Persistent = true;
    };
    Install = lib.optionalAttrs startTimer { WantedBy = [ "timers.target" ]; };
  };
}
