{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.element-call;
in
{
  meta.maintainers = with maintainers; [ kilimnik ];

  options = {
    services.element-call = {
      enable = mkEnableOption (mdDoc "element-call");

      package = mkPackageOption pkgs "element-call" { };

      hostName = mkOption {
        type = types.str;
        example = "call.example.org";
        description = mdDoc ''
          FQDN of the Element Call instance.
        '';
      };

      livekitServiceUrl = mkOption {
        type = types.nonEmptyStr;
        description = mdDoc "URL of the LiveKit JWT service";
        example = "https://livekit-jwt.call.element.dev";
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = { };
        description = mdDoc ''
          Extra configuration for element call
          See [here](https://github.com/element-hq/element-call/blob/livekit/src/config/ConfigOptions.ts)
        '';
      };

      caddy.enable = mkEnableOption (mdDoc "exposing element-call with the caddy reverse proxy");
      nginx.enable = mkEnableOption (mdDoc "exposing element-call with the nginx reverse proxy");
    };
  };

  config =
    let
      livekitConfig = pkgs.writeText "config.json" (builtins.toJSON ({
        livekit = {
          livekit_service_url = cfg.livekitServiceUrl;
        };
      } // cfg.extraConfig));
    in
    mkIf
      cfg.enable
      {
        services.caddy = mkIf cfg.caddy.enable {
          enable = mkDefault true;
          virtualHosts.${cfg.hostName} = {
            extraConfig = ''
              handle_path /config.json {
                root * ${livekitConfig}
                file_server
              }
              handle {
                root * ${cfg.package}/dist
                file_server
              }
            '';
          };
        };

        services.nginx = mkIf cfg.nginx.enable {
          enable = mkDefault true;
          virtualHosts.${cfg.hostName} = {
            locations = {
              "=/config.json" = {
                alias = livekitConfig;
              };
              "/" = {
                root = "${cfg.package}/dist";
              };
            };
          };
        };
      };
}
