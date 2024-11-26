
<div align="center">
   
[![nixos](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org/)
[![neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)
[![xmonad](https://img.shields.io/badge/xmonad-%23fc4c5c.svg?style=for-the-badge&logo=xmonad&logoColor=white)](https://xmonad.org/)
[![haskell](https://img.shields.io/badge/Haskell-5D4F85?style=for-the-badge&logo=haskell&logoColor=white)](https://www.haskell.org/)

</div>

## 📖 About

NixOS system config and Home-Manager user config.

## 🌟 Showcase

## 🔧 Components

| Component        | Version/Name                                                                                               |
|------------------|------------------------------------------------------------------------------------------------------------|
| Distro           | ![NixOS](https://nixos.org/)                                                                               |
| Shell            | ![Fish](https://fishshell.com/)                                                                            |
| Display Server   | Wayland                                                                                                    |
| WM (Compositor)  | ![XMonad](https://xmonad.org/) + ![picom-pijulius](https://github.com/pijulius/picom)                      |
| Bar              | ![Xmobar](https://codeberg.org/xmobar/xmobar)                                                              |
| Launcher         | ![Rofi-Wayland](https://github.com/lbonn/rofi)                                                             |
| Editor           | ![Custom Nixvim](https://github.com/dsunshi/nixvim)                                                        |
| Terminal         | ![Kitty](https://sw.kovidgoyal.net/kitty/) + ![Starship](https://starship.rs/)                             |
| Fetch Utility    | Neofetch                                                                                                   |
| Theme            | ![Kanagawa Paper](https://github.com/sho-87/kanagawa-paper.nvim)                                           |
| Font             | ![Iosevka](https://github.com/be5invis/Iosevka) + ![Nerd Font Patch](https://www.nerdfonts.com/)           |
| Player           | Spotify                                                                                                    |
| File Browser     | ![Yazi](https://yazi-rs.github.io/)                                                                        |
| Internet Browser | ![Qutebrowser](https://www.qutebrowser.org/), Firefox                                                      |
| Image Editor     | ![Gimp](https://www.gimp.org/)                                                                             |
| Screenshot       | ![Flameshot](https://flameshot.org/)                                                                       |
| Color Picker     | ![Gpick](https://www.gpick.org/)                                                                           |
| Wallpaper        | ![Feh](https://feh.finalrewind.org/)                                                                       |
| Graphical Boot   | ![Distro-grub-theme](https://github.com/AdisonCavani/distro-grub-themes) + "nixos" theme                   |
| Display Manager  | ![Lightdm](https://github.com/canonical/lightdm) + ![mini](https://github.com/prikhi/lightdm-mini-greeter) |
| Containerization | ![Distrobox](https://github.com/89luca89/distrobox) + ![Podman](https://podman.io/)                        |

## ⌨️ Keybindings

| Key | Description |
| --- | ----------- |
| <kbd>Super</kbd> | XMonad mod key |
| <kbd>Super</kbd> + <kbd>SHIFT</kbd> + <kbd>h</kbd> | Display help menu of all XMonad key bindings |

### Main

## 🚀 Installation

Currently there are two seperate profiles or hosts provided by this configuration:
 - [bandit](./hosts/bandit) - My personal laptop/desktop
 - [ghost](./hosts/ghost) - WSL configuration for use at work

1. Check out this repo.
2. Use one of the following two commands to install either bandit or ghost.
3. After the initial installation it is possible to use `make install` for either profile. This is possible since `nh` can detect the current system.

### Bandit Installation

```bash
sudo nixos-rebuild switch --flake .#bandit
```

### Ghost Installation

```bash
sudo nixos-rebuild switch --flake .#ghost
```
