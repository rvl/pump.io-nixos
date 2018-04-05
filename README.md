# pump.io Module for NixOS

[pump.io][] - Social server with an ActivityStreams API.

Version 5.1.0.

## What is it?

[pump.io][] is an interesting federated social networking
server. There are many public servers which you can use for free, or
you can run your own. The latter option is what this document is
about, specifically, how to do it on the best and most advanced
operating system: NixOS.

[pump.io][] could be merged into the main NixOS/Nixpkgs collection,
but because it would have relatively few users, I would prefer not to
burden the NixOS project with maintenance of this module. The good
news is that it's quite simple to run modules from external
out-of-tree resources. So you can easily set up and try this software
by adding a few things to your `configuration.nix`.

## About the module

The pump.io module comes in two parts, as do most NixOS service
modules.

The first part is the Nix package, which is a build recipe for the
software. The built package will contain a `bin` directory with the
pump.io server and related tools. You don't really need to worry about
this part.

The second part is the NixOS service module. It's like a [Puppet][]
script which sets up the configuration files according to sensible
high-level options, ensures that the Nix package is installed, and
adds a systemd service for it.

## Requirements

You need to be running NixOS 18.03.

## How to install

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
    sslCert = "/run/keys/snakeoil.cert";
    sslKey = "/run/keys/snakeoil.key";
  };
 
  services.mongodb.enable = true;
}
```

After running `nixos-rebuild switch` you should have a pump.io server
listening https://localhost:31337/ which you can register a user on.

It is also possible to configure NGINX as a reverse proxy for pump.io,
and/or run the service within a NixOS container, if you wish.

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
[Puppet]: https://github.com/puppetlabs/puppet
