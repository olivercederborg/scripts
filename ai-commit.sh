#!/bin/sh

gum spin --title "Generating" -- open -g "raycast://extensions/hifranklin/ai-develoment-tools/generate-pwd-commit?arguments={\"pwd\":\"$(pwd)\"}" && gum confirm "Commit with message: "$pbpaste"?" && git commit -m "$pbpaste"

