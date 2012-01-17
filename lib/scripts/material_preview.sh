#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
blender -t 1 -b $DIR/render.blend -P $DIR/material_preview.py "$1" 2> /dev/null
