{ pkgs, config, ... }:
let
  key = config.age.secrets."expressvpn-key".path;
  vpn = pkgs.writeShellScriptBin "vpn" # bash
    ''
      #!/usr/bin/env bash
      connect_cmd() {
        expressvpn connect
      }

      connect() {
        . <({ verr=$({ mapfile -t vout< <(connect_cmd; vret=$?; declare -p vret >&3); } 3>&2 2>&1; declare -p vout >&2); declare -p verr; } 2>&1)

        echo "stdout: $vout"
        echo "stderr: $verr"
        echo "return code: $vret"

        return $vret
      }

      activate() {
        key=${key}
        echo "Attempting to activate with key: $key"
        # expressvpn activate < $key
      }

      main() {
        # Try and connect
        activate
        # echo "Attempting to connect"
        # connect
        # if [ $? -ne 0 ]; then
        #   echo "Failed to connect"
        # fi
      }

      main "$@"

    '';
in {
  services.expressvpn.enable = true;
  environment.systemPackages = with pkgs; [ expressvpn vpn ];
}
