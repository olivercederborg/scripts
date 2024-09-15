#!/bin/zsh

# Get the list of staged files
files=$(git status --short | grep '^??\|^M \|^D \|^A \|^R ')

if [ -z "$files" ]; then
    echo "No files to unstage."
    exit 0
fi

# Use gum to pick files
chosen_files=$(echo $files | gum choose --no-limit --header "Stage files:" --cursor "👉 " --selected.foreground 10 | awk '{print $2}')

if [ -z "$chosen_files" ]; then
    echo "No files selected."
    exit 0
fi

# Stage the files using git add
echo $chosen_files | sed -e 's/^/"/; s/$/"/' | xargs git restore

# Count the total number of files
total_files=$(echo $chosen_files | wc -w | awk '{$1=$1};1')

styled_output=$(gum style --foreground 196 "+$total_files")
echo "$styled_output files have been unstaged."
