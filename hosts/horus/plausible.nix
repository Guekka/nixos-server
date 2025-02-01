{config, ...}: {
  services.plausible = {
    enable = true;

    server = {
      baseUrl = "https://plausible.bizel.fr";
      port = 4004;
      secretKeybaseFile = config.sops.secrets.plausibleKey.path;
    };

    adminUser = {
      activate = true;
      email = "trucmuche909@gmail.com";
      passwordFile = config.sops.secrets.plausibleAdmin.path;
    };
  };

  services.nginx.virtualHosts."plausible.bizel.fr" = {
    useACMEHost = "bizel.fr";
    forceSSL = true;
    locations."^~ /" = {
      proxyPass = "http://127.0.0.1:${toString config.services.plausible.server.port}";
    };
  };

  environment.etc = {
    # From https://github.com/plausible/hosting/tree/master/clickhouse
    "clickhouse-server/config.d/nologs.xml".text = ''
      <clickhouse>
          <logger>
              <level>warning</level>
              <console>true</console>
          </logger>
          <query_thread_log remove="remove"/>
          <query_log remove="remove"/>
          <text_log remove="remove"/>
          <trace_log remove="remove"/>
          <metric_log remove="remove"/>
          <asynchronous_metric_log remove="remove"/>
          <session_log remove="remove"/>
          <part_log remove="remove"/>
      </clickhouse>
    '';

    "clickhouse-server/users.d/nologs.xml".text = ''
      <clickhouse>
          <profiles>
              <default>
                  <log_queries>0</log_queries>
                  <log_query_threads>0</log_query_threads>
              </default>
          </profiles>
      </clickhouse>
    '';
  };

  environment.persistence."/persist/backup" = {
    directories = [
      {
        directory = "/var/lib/clickhouse";
        mode = "0750";
        user = "clickhouse";
        group = "clickhouse";
      }
      {
        directory = "/var/lib/private/plausible";
        mode = "0750";
        user = "plausible";
        group = "plausible";
      }
    ];
  };

  sops.secrets = {
    plausibleAdmin = {
      sopsFile = ./secrets.yaml;
    };
    plausibleKey = {
      sopsFile = ./secrets.yaml;
    };
    plausibleCookiePath = {
      sopsFile = ./secrets.yaml;
    };
  };
}
