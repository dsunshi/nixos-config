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
        if [[ $verr == *"connect again"* ]]; then
          # expressvpn status
          # exit 0
          return 0
        fi
        return $vret
      }

      activate() {
        key=$(cat ${key})
        setxkbmap -layout us
        xdotool sleep 0.45 type "$key" &
        xdotool sleep 0.70 key Return &
        xdotool sleep 2.50 type "n" &
        xdotool sleep 3.00 key Return &
        # Suppress output
        . <({ verr=$({ mapfile -t vout< <(expressvpn activate; vret=$?; declare -p vret >&3); } 3>&2 2>&1; declare -p vout >&2); declare -p verr; } 2>&1)
        # Restore original keymap (if needed)
        # TODO: variant from Nix config?
        len=$(setxkbmap -query | grep variant | wc -c)
        if [ $len -ne 0 ]; then
          setxkbmap -layout us -variant colemak_dh_ortho
        fi
      }

      main() {
        connect
        if [ $? -ne 0 ]; then
          activate
          connect
        fi
        expressvpn status
      }

      main "$@"
    '';
in {
  services.expressvpn.enable = true;
  environment.systemPackages = with pkgs; [ expressvpn vpn ];
}
