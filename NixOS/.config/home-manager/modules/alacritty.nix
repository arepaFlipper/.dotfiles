{
  programs.alacritty = {
    enable = true;
    settings = {
      working_directory = "None";
      # import = [
      #   "${toString ./path/to/your/themes/catppuccin/catppuccin-frappe.toml}"
      # ];

      cursor = {
        blink_interval = 200;
        style = {
          shape = "Beam";
          blinking = "Always";
        };
      };

      colors = {
        bright = {
          black = "0x808080";
          blue = "0x0066ff";
          cyan = "0x00ffff";
          green = "0x00d900";
          magenta = "0xcc00ff";
          red = "0xfe0100";
          white = "0xFFFFFF";
          yellow = "0xfeff00";
        };
        cursor = {
          cursor = "0xffffff";
          text = "0xF81CE5";
        };
        normal = {
          black = "0x000000";
          blue = "0x0066ff";
          cyan = "0x00ffff";
          green = "0x00a600";
          magenta = "0xcc00ff";
          red = "0xfe0100";
          white = "0xd0d0d0";
          yellow = "0xfeff00";
        };
      };

      env = {
        "TERM" = "tmux-256color";
      };

      # font = {
      #   size = 12;
      #   bold = {
      #     family = "JetBrains Mono ExtraBold";
      #     style = "Bold";
      #   };
      #   italic = {
      #     family = "Nimbus Mono PS";
      #     style = "Italic";
      #   };
      #   normal = {
      #     family = "JetBrainsMono Nerd Font";
      #     style = "Regular";
      #   };
      # };

      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
      };

      window = {
        dimensions = {
          columns = 140;
          lines = 38;
        };
        padding = {
          x = 6;
          y = 4;
        };
      };
    };
  };
}

