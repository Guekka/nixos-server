{
  dconf = {
    enable = true;
    settings = {
      # ...
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "pop-launcher-super-key@ManeLippert"
          "pop-shell@system76.com"
        ];
      };
    };
  };
}
