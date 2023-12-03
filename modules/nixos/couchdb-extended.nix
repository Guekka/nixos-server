{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.couchdbExtended;
in {
  options.services.couchdbExtended = {
    ensureAdminUser = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the user to create";
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
        description = "The file containing the password to use for the user";
      };
    };
  };

  config = {
    systemd.services.couchdb-setup = {
      description = "Creates users for couchdb";

      after = ["couchdb.service" "network-pre.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig.Type = "oneshot";

      script = let
        cdb_cfg = config.services.couchdb;
        host = "http://${cdb_cfg.adminUser}:${cdb_cfg.adminPass}@${cdb_cfg.bindAddress}:${toString cdb_cfg.port}";
        curl = "${lib.getExe pkgs.curl}";
      in ''
        set -e

        # Wait for couchdb to start. Try at most 5 times.
        for i in $(seq 1 5); do
          if ${curl} -X GET ${host}/_up -s -o /dev/null; then
            break
          fi
          sleep 1
        done

        if ! ${curl} -X GET ${host}/_up -s -o /dev/null; then
          echo "Couchdb did not start" >&2
          exit 1
        fi

        # create necessary databases
        ${curl} -X PUT ${host}/_users || true
        ${curl} -X PUT ${host}/_replicator || true
        ${curl} -X PUT ${host}/_global_changes || true

        if [ -f ${cfg.ensureAdminUser.passwordFile} ]; then
          password=$(cat ${cfg.ensureAdminUser.passwordFile})
        else
          echo "Password file ${cfg.ensureAdminUser.passwordFile} does not exist" >&2
        fi

        echo ${curl} -X PUT ${host}/_node/_local/_config/admins/${cfg.ensureAdminUser.name} -d '"$password"'
        ${curl} -X PUT ${host}/_node/_local/_config/admins/${cfg.ensureAdminUser.name} -d \"$password\"
      '';
    };
  };
}
