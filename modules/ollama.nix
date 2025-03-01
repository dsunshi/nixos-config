{ pkgs, ... }: {
  services.ollama.enable = true;
  services.ollama.acceleration = "cuda";
  services.open-webui.enable = true;
}
