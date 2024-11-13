
# Bootstrap

Use at your own risk
```bash
bash <(curl -s https://raw.githubusercontent.com/dsunshi/nixos-config/refs/heads/master/bootstrap.sh)
```

# How to change the username in WSL

This configuration sets `wsl.defaultUser`.
Follow these instructions to make sure, the change gets applied correctly:

1. Apply the configuration:\
   `sudo nixos-rebuild boot`\
   Do not use `nixos-rebuild switch`! It may lead to the new user account being misconfigured.
2. Exit the WSL shell and stop your NixOS distro:\
   `wsl -t NixOS`.
3. Start a shell inside NixOS and immediately exit it to apply the new generation:\
   `wsl -d NixOS --user root exit`
4. Stop the distro again:\
   `wsl -t NixOS`
5. Open a WSL shell. Your new username should be applied now!