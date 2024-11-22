
# Installing Windows Subsystem for Linux (WSL)

## Enable WSL
> [!IMPORTANT]
> Run the following commands from an **admin** shell:

### Using PowerShell
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

### Or using Command Prompt and DISM
Run the following command from an **admin** shell:
```cmd
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Windows-Subsystem-Linux /norestart
DISM /Online /Enable-Feature /All /FeatureName:VirtualMachinePlatform /norestart
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /norestart
```

## Install WSL
> [!IMPORTANT]
> Run the following command from a **non-admin** shell:
```cmd
wsl --install
```

## Updating WSL
> [!IMPORTANT]
> Run the following command from a **non-admin** shell:
```cmd
wsl --update --web-download
```

# Running WSL
To enter the WSL environment simply execute:
```cmd
wsl
```
This will launch the default linux OS.

```cmd
wsl --install
wsl --update --web-download
```

If you run `wsl` and nothing happens (no errors reported, but WSL does not launch). Then run the above commands again.

# Installing NixOS-WSL

1. First, [download the latest release](https://github.com/nix-community/NixOS-WSL/releases/latest).
2. Import NixOS-WSL (run these commands in the same folder where the release `nixos-wsl.tar.gz` was downloaded):
Using PowerShell:
```powershell
wsl --import NixOS $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz
```
Using Command Prompt:
```cmd
wsl --import NixOS %USERPROFILE%\NixOS\ nixos-wsl.tar.gz
```
3. Enter the NixOS environment
```sh
wsl -d NixOS
```
> [!IMPORTANT]
> 4. After the initial installation, you need to update your channels once, to be able to use `nixos-rebuild`:
```sh
sudo nix-channel --update
```

To optionally set NixOS as the default for WSL:
```cmd
wsl -s NixOS
```

## 🚨 How to update the username in WSL

This configuration sets `wsl.defaultUser`.
Follow these instructions to make sure, the change gets applied correctly:

1. Apply the configuration:\
   `sudo nixos-rebuild boot --flake .#ghost`
> [!CAUTION]
> Do not use `nixos-rebuild switch`! It may lead to the new user account being misconfigured.
2. Exit the WSL shell and stop your NixOS distro:\
   `wsl -t NixOS`.
3. Start a shell inside NixOS and immediately exit it to apply the new generation:\
   `wsl -d NixOS --user root exit`
4. Stop the distro again:\
   `wsl -t NixOS`
5. Open a WSL shell. Your new username should be applied now!
