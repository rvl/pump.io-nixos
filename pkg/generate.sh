#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix jshon nix gnused

# fixme: nix-shell  --pure, node2nix -8

set -e
cd $(dirname $0)

# Normally, this node2nix invocation would be sufficient:
#   exec node2nix --input node-packages.json --composition composition.nix
#
# But pump.io soft-depends on extra modules, which have to be *inside*
# its own node_modules, not beside them.
#
# So we hack these extra deps into package.json and feed that into
# node2nix.
#
# Also jshon does funny things with slashes in strings, which can be
# fixed with sed.

VERSION=${1:-5.1.0}
URL="https://registry.npmjs.org/pump.io/-/pump.io-$VERSION.tgz"
prefetch=( $(nix-prefetch-url --type sha512 --print-path "$URL") )
SHA512=${prefetch[0]}

tar -Oxf ${prefetch[1]} package/package.json \
    | jshon -e dependencies                  \
          -s '*' -i databank-mongodb         \
          -s '*' -i databank-redis           \
          -s '*' -i databank-lrucache        \
          -p                                 \
    | sed 's=\\/=/=g'                        \
    > package.json

node2nix -8 --input package.json --composition composition.nix

# overriding nodePackages src doesn't seem to work, so...
sed -i "s|src = ./.|src = fetchurl { url = \"$URL\"; sha512 = \"$SHA512\"; }|" node-packages.nix
