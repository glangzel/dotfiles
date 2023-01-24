#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for dotfile in "${SCRIPT_DIR}"/.??* ; do
    [[ "$dotfile" == "${SCRIPT_DIR}/.git" ]] && continue
    [[ "$dotfile" == "${SCRIPT_DIR}/.github" ]] && continue

    if [ -d $dotfile ]; then
        cp -r "$dotfile" "$HOME"
    elif [ -e $dotfile ]; then
        cp "$dotfile" "$HOME"
    else
        continue
    fi
done