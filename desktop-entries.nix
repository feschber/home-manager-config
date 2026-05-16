{ pkgs, ... }:
{
  xdg.desktopEntries = {
    boot_windows = {
      name = "Boot Windows";
      genericName = "Boot Windows";
      exec = "${pkgs.bash}/bin/bash -c \"${pkgs.efibootmgr}/bin/efibootmgr -n 2; reboot\"";
      terminal = false;
      categories = [ "Utility" ];
    };
  };
}
