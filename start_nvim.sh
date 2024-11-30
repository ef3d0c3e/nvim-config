#!/usr/bin/env bash
[ -z $NVIM ] && nvim --listen ~/.cache/nvim/server${RANDOM}.pipe $* || nvim --server $NVIM --remote $*
