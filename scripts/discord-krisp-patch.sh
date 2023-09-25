#!/usr/bin/env nix-shell
#!nix-shell -i bash -p rizin

# from: https://github.com/NixOS/nixpkgs/issues/195512#issuecomment-1546794291

set -e

discord_version="0.0.28"
addr=$(rz-find -x '4881ec00010000' discord_krisp.node | head -n1)
rizin -q -w -c "s $addr + 0x30 ; wao nop" "${HOME}/.config/discord/${discord_version}/modules/discord_krisp/discord_krisp.node"
