{ ... }: {
  # https://nixos.wiki/wiki/Power_Management
  # thermald proactively prevents overheating on Intel CPUs and works well with other tools.
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      # Optional, but helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # <-- and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # <-- and above it stops charging
    };
  };
}
