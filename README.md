# pump.io Module for NixOS

[pump.io][] - Social server with an ActivityStreams API.

Version 5.1.0.

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

When there is a new upstream release:

    ./pkgs/generate.sh VERSION
    nix build -f ./pkgs/composition.nix package

This will fetch the given version of [pump.io from npm][npm] and
re-run [node2nix][].

[pump.io]: http://pump.io
[npm]: https://npmjs.com/package/pump.io
[node2nix]: https://github.com/svanderburg/node2nix
