#!/bin/sh
clear

function cleanup {
  yadm restore --staged $FILES
}

UNSTAGED=$(yadm status | sed -e '1,/commit:/d' | sed -n 's/.*modified://p; s/.*deleted://p')

# if no files to manage, exit
if [ -z "$UNSTAGED" ]; then
  clear && echo "$(gum style --foreground 212 "No files to add.")" && exit 0
fi

echo "Pick your dotfiles to $(gum style --foreground 212 "add")."
FILES=$(gum choose --no-limit $UNSTAGED)

# if no files were selected, exit
if [ -z "$FILES" ]; then
  exit 0
fi

yadm add $FILES

echo "Choose the type of commit."
TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
SCOPE=$(gum input --placeholder "scope e.g. nvim")

# Since the scope is optional, wrap it in parentheses if it has a value.
[[ -n "$SCOPE" ]] && SCOPE="($SCOPE)"

# Pre-populate the input with the type(scope): so that the user may change it
SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change"); clear

SUCCESS=$(gum style "Your dotfiles were pushed $(gum style --foreground 79 "successfully")!")
FAILURE=$(gum style "Nothing was pushed, $(gum style --foreground 9 "sadly")...")

# cleanup before exit
trap cleanup EXIT

# Commit and push
gum confirm "commit and push?" && yadm commit -m "$SUMMARY" && yadm push && echo "$SUCCESS" || echo "$FAILURE"

