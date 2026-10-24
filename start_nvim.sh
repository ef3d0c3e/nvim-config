#!/usr/bin/env bash

# --remote resolves relative paths against the server's cwd, so absolutize
# file arguments before sending them to an existing session
ARGS=()
for a in "$@"; do
	case "${a}" in
	-* | +*) ARGS+=("${a}") ;;
	*) ARGS+=("$(realpath -m -- "${a}")") ;;
	esac
done

# Inside an nvim :terminal the surrounding instance is the session
if [ -n "${NVIM}" ]; then
	exec nvim --server "${NVIM}" --remote "${ARGS[@]}"
fi

# One session per terminal: derive a stable socket path from the tty
TTY_ID="$(tty 2>/dev/null || echo "unknown-$$")"
TTY_ID="${TTY_ID#/}"
SOCK="${XDG_RUNTIME_DIR:-${HOME}/.cache}/nvim/session-${TTY_ID//\//-}.pipe"
mkdir -p "$(dirname "${SOCK}")"

# If a server is already listening on this terminal's socket, open there
if [ $# -gt 0 ] && [ -e "${SOCK}" ] \
	&& nvim --server "${SOCK}" --remote-expr 1 >/dev/null 2>&1; then
	exec nvim --server "${SOCK}" --remote "${ARGS[@]}"
fi

# No live session for this shell: start a new one
rm -f "${SOCK}"
exec nvim --listen "${SOCK}" "$@"
