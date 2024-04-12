{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lk-jwt-service;
in
{
  meta.maintainers = with maintainers; [ kilimnik ];

  options = {
    services.lk-jwt-service = {
      enable = mkEnableOption (mdDoc "lk-jwt-service");

      package = mkPackageOption pkgs "lk-jwt-service" { };

      livekitUrl = mkOption {
        type = types.nonEmptyStr;
        description = mdDoc "URL of the LiveKit server";
        example = "ws://somewhere";
      };

      port = mkOption {
        type = types.port;
        description = mdDoc "Port to listen on";
        default = 8080;
      };

      openFirewall = mkOption {
        type = types.bool;
        description = mdDoc "Open the port in the firewall";
        default = false;
      };

      environmentFile = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          File path containing the credentials for LiveKit (LIVEKIT_KEY, LIVEKIT_SECRET), 
          in the format of an EnvironmentFile as described by systemd.exec(5)
        '';
        example = "/var/src/secrets/lk-jwt-service.env";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall [ cfg.port ];

    systemd.services.lk-jwt-service = {
      description = cfg.package.meta.description;

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        LIVEKIT_URL = cfg.livekitUrl;
        LK_JWT_PORT = toString cfg.port;
      };

      script = "${cfg.package}/bin/lk-jwt-service";

      serviceConfig = {
        DynamicUser = true;
        User = "lk-jwt-service";
        Group = "lk-jwt-service";
        EnvironmentFile = cfg.environmentFile;
      };
    };
  };
}
