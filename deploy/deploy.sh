#!/usr/bin/env bash

# Deploy script for my nvim configuration

DEPLOY_DIR=$(dirname "$(realpath $0)")

deploy_file()
{
	echo "> Deploying '$1' -> '$2'"
	# TODO: Create paths
	cp "${DEPLOY_DIR}/$1" $2
}

deploy_clangd()
{
	echo "Deploying clangd configuration..."
	deploy_file "clangd" "$XDG_CONFIG_HOME/clangd/config.yaml"
	deploy_file "clang-format" "$HOME/.clang-format"
}

deploy_clangd
