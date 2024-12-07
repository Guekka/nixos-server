{
  services.nfs = {
    server = {
      enable = true;
      exports = ''
        /shared *(rw,async,wdelay,root_squash,no_subtree_check)
      '';
    };
  };
}
