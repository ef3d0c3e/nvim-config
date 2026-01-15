#!/usr/bin/env bash

if [ -z "${NVIM}" ]; then
	SOCK="${HOME}/.cache/nvim/server${RANDOM}.pipe"
	SOCK_DIR="$(dirname """${SOCK}""")"
	if [ ! -d "${SOCK_DIR}" ]; then
		mkdir -p "${SOCK_DIR}"
	fi
	nvim --listen "${SOCK}" "$@"
else
	nvim --server "${NVIM}" --remote "$@"
fi
