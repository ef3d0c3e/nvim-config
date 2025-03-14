#!/usr/bin/env bash

# Deploy script for my nvim configuration

DEPLOY_DIR=$(dirname "$(realpath $0)")

deploy_file()
{
	echo "> Deploying '$1' -> '$2'"
	cp "${DEPLOY_DIR}/$1" $2
}

deploy_clangd()
{
	echo "Deploying clangd configuration..."
	deploy_file "clangd" "$HOME/.clangd"
}

deploy_clangd
