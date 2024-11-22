
# Displaylink

## DisplayLink monitors

In order to use Displaylink monitors over USB, the displaylink driver needs to be installed:

```nix
$ services.xserver.videoDrivers = [ "displaylink" ... ];
```
> [!NOTE]
> Since these drivers depend on binary unfree blobs, you will need to first add it to your nix-store. 

Go to https://www.displaylink.com/downloads/ubuntu to get the appropriate driver version and note the download URL you get after accepting the EULA.

The currently expected version for the driver can be found under: https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu-5.8?filetype=exe.

> [!CAUTION]
> In order to build the full system correctly the downloaded zip needs renamed `displaylink-580.zip`. **And** placed in this `depends/` folder.

## Makefile

When running `make install` it will detect the presecene of `depends/displaylink-580.zip` and automatically enable a `displaylink` [specialisation](https://nixos.wiki/wiki/Specialisation).

> [!WARNING]
> If `depends/displaylink-580.zip` is not found. Then the system will still build but the `displaylink` specialisation will not be enabled.
