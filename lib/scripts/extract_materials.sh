#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
blender -b "$1" -P $DIR/extract_materials.py 2> /dev/null
