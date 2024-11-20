
<div align="center">
   
[![nixos](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org/)
[![neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![xmonad](https://img.shields.io/badge/xmonad-%23fc4c5c.svg?style=for-the-badge&logo=xmonad&logoColor=white)](https://xmonad.org/)
[![haskell](https://img.shields.io/badge/Haskell-5D4F85?style=for-the-badge&logo=haskell&logoColor=white)](https://www.haskell.org/)

</div>

## 📖 About

## 🌟 Showcase

## 🔧 Components

| Component        | Version/Name                                                     |
|------------------|------------------------------------------------------------------|
| Distro           | NixOS                                                            |
| Shell            | Fish                                                             |
| Display Server   | Wayland                                                          |
| WM (Compositor)  | XMonad + picom-pijulius                                          |
| Bar              | XMobar                                                           |
| Launcher         | Rofi-Wayland                                                     |
| Editor           | ![Custom Nixvim](https://github.com/dsunshi/nixvim)              |
| Terminal         | Kitty + Starship                                                 |
| Fetch Utility    | Neofetch                                                         |
| Theme            | ![Kanagawa Paper](https://github.com/sho-87/kanagawa-paper.nvim) |
| Font             | Ioseveka Mono + Nerd Font Patch                                  |
| Player           | Spotify                                                          |
| File Browser     | Yazi                                                             |
| Internet Browser | Qutebrowser, Firefox                                             |
| Image Editor     | Gimp                                                             |
| Screenshot       | Flameshot                                                        |
| Color Picker     | Gpick                                                            |
| Wallpaper        | Feh                                                              |
| Graphical Boot   | Distro-grub-theme + nixos                                        |
| Display Manager  | Lightdm + mini                                                   |
| Containerization | Distrobox + Podman                                               |

## ⌨️ Keybindings

### Main

## 🚀 Installation

## 🚨 How to change the username in WSL

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
