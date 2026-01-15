#!/usr/bin/env bash

if [ -z "${NVIM}" ]; then
	nvim --listen ~/.cache/nvim/server${RANDOM}.pipe "$@"
else
	nvim --server "${NVIM}" --remote "$@"
fi
