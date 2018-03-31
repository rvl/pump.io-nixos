# pump.io Module for NixOS

Version 3.0.0.

## Requirements

You need to be running NixOS 18.03.

## Setup

Add the following to your `configuration.nix`:

```nix
{ config, pkgs, ... }:
{
  imports = [ (builtins.fetchGit https://github.com/rvl/pump.io-nixos + "/module.nix") ];

  services.pumpio = {
    enable = true;
    secretFile = "/run/keys/pump.io-secret.txt";
    site = "Twit twit";
    owner = "me.name";
    ownerURL = "https://me.name";
    disableRegistration = false;
    dbName = "pumpio";
    port = 31337;
    hostname = "me.name";
    sslCert = "/run/keys/snakeoil.cert";
    sslKey = "/run/keys/snakeoil.key";
  };
 
  services.mongodb.enable = true;

  networking.firewall.allowedTCPPorts = [ 443 ];
}
```


## Running tests

    nix build -f test.nix

## Updating package version

For a new upstream release.

    $(nix build --no-out-link pkg/updater.nix)/bin/update
