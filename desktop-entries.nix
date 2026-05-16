{ ... }:
{
  boot_windows = {
    name = "Boot Windows";
    genericName = "Boot Windows";
    exec = "bash -c 'efibootmgr -n 2; reboot'";
    terminal = false;
    categories = [ "Utilities" ];
  };
}
