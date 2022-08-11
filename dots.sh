#!/bin/sh
clear

UNSTAGED=$(yadm status | sed -e '1,/commit:/d' | sed -n 's/.*modified://p; s/.*deleted://p')
echo "Pick your dotfiles to $(gum style --foreground 212 "add")."
FILES=$(gum choose --no-limit $UNSTAGED)
yadm add $FILES

# clear; echo "Choose the type of commit."

TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
SCOPE=$(gum input --placeholder "scope e.g. nvim")

# Since the scope is optional, wrap it in parentheses if it has a value.
[[ -n "$SCOPE" ]] && SCOPE="($SCOPE)"

# Pre-populate the input with the type(scope): so that the user may change it
SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")

clear

# Commit these changes
gum confirm "Commit changes?" && yadm commit -m "$SUMMARY"

SUCCESS=$(gum style --height 2 --width 25 --padding '1 3' --border double --border-foreground 79 "Your dotfiles were pushed $(gum style --foreground 79 "successfully")!")
FAILURE=$(gum style --height 2 --width 25 --padding '1 3' --border double --border-foreground 79 "Nothing was pushed, $(gum style --foreground 9 "sadly")...")

gum confirm "Push it?" && yadm push && echo "$SUCCESS" || echo "$FAILURE"

