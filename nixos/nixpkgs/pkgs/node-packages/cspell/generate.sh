#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

node2nix --nodejs-10 \
	--input node-packages.json \
	--output node-packages.nix \
	--composition cspell.nix \
	--node-env ../node-env.nix \
	--no-copy-node-env
