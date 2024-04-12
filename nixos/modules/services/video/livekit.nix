{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.livekit;
in
{
  options = {
    services.livekit = {
      enable = mkEnableOption (mdDoc "the livekit server");

      package = mkPackageOption pkgs "livekit" { };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to open ports in the firewall for livekit.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 7880;
        description = mdDoc ''
          main TCP port for RoomService and RTC endpoint
        '';
      };

      keysFile = mkOption {
        type = types.nullOr types.path;
        example = "/var/src/secrets/livekit.keys";
        description = mdDoc ''
          Path to the keys file for livekit in yaml or json format
          See [here](https://github.com/livekit/livekit/blob/41b70ef555e3f501300b413d6fc5c1a414fdb7a1/config-sample.yaml#L152)
          ```
          {
              "key1": "secret1",
              "key2": "secret2"
          }
          ```
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        description = mdDoc ''
          Extra configuration for livekit
          See [here](https://github.com/livekit/livekit/blob/master/config-sample.yaml)
        '';
      };
    };
  };

  config =
    let
      livekitConfig = pkgs.writeText "config.json" (builtins.toJSON (
        {
          port = cfg.port;
        } // cfg.extraConfig
      ));
    in
    mkIf cfg.enable
      {
        networking.firewall.allowedTCPPorts = optionals cfg.openFirewall [ cfg.port ];

        systemd.services.livekit =
          {
            description = cfg.package.meta.description;
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            script = ''
              ${cfg.package}/bin/livekit-server --config ${livekitConfig} --key-file $\{CREDENTIALS_DIRECTORY}/keys
            '';
            serviceConfig = {
              DynamicUser = true;
              User = "livekit";
              Group = "livekit";
              LoadCredential = "keys:${cfg.keysFile}";
            };
          };
      };
}
