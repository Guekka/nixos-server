{
  environment.sessionVariables.DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";

  virtualisation.docker = {
    enable = true;
  };

  environment.persistence = {
    "/persist/nobackup".directories = [
      "/var/lib/containers"
    ];
  };
}
