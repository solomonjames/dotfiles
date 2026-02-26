#!/bin/bash

set -euo pipefail

echo "Cleaning up antigen artifacts..."

rm -f "$HOME/.local/bin/antigen.zsh"
rm -rf "$HOME/.antigen"
rm -f "$HOME"/.zcompdump*

echo "Antigen cleanup complete."
