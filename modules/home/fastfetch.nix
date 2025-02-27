{ myUser, ... }: {
  home-manager.users.${myUser.username} = {
    programs.fastfetch.enable = true;

    programs.fastfetch.settings = {
      # logo.type = "nixos";
      display = {
        separator = "➤   ";
        color = { separator = "cyan"; };
      };
      modules = [
        {
          type = "custom";
          format =
            "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ System Information ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓";
        }
        {
          key = "    󰻀 OS           ";
          keyColor = "magenta";
          type = "os";
        }
        {
          key = "     Kernel       ";
          keyColor = "white";
          type = "kernel";
        }
        {
          key = "    󰏖 Packages     ";
          keyColor = "yellow";
          type = "packages";
        }
        {
          key = "     WM           ";
          keyColor = "blue";
          type = "wm";
        }
        {
          key = "     Terminal     ";
          keyColor = "red";
          type = "terminal";
        }
        {
          key = "     Shell        ";
          keyColor = "yellow";
          type = "shell";
        }
        {
          key = "    󰅐 Uptime       ";
          keyColor = "green";
          type = "uptime";
        }
        {
          type = "custom";
          format =
            "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫";
        }
        {
          key = "    󰌢 Machine      ";
          keyColor = "magenta";
          type = "host";
        }
        {
          key = "    󰻠 CPU          ";
          keyColor = "bright_green";
          type = "cpu";
        }
        {
          key = "    󱤓 GPU          ";
          keyColor = "red";
          type = "gpu";
        }
        {
          key = "    󰍛 RAM          ";
          keyColor = "yellow";
          type = "memory";
        }
        {
          key = "     Disk         ";
          keyColor = "bright_cyan";
          type = "disk";
        }
        {
          type = "custom";
          format =
            "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛";
        }
        {
          type = "colors";
          paddingLeft = 34;
          symbol = "diamond";
        }
      ];
    };
  };
}
