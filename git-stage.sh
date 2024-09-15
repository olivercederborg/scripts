#!/bin/zsh

# Get the list of changed files
files=$(git status --short | grep '^??\|^ M\|^ D')

if [ -z "$files" ]; then
    echo "No changes to stage."
    exit 0
fi

# Use gum to pick files
chosen_files=$(echo $files | gum choose --no-limit --header "Stage files:" --cursor "👉 " --selected.foreground 10 | awk '{print $2}')

if [ -z "$chosen_files" ]; then
    echo "No files selected."
    exit 0
fi

# Stage the files using git add
echo $chosen_files | sed -e 's/^/"/; s/$/"/' | xargs git add

# Count the total number of files
total_files=$(echo $chosen_files | wc -w | awk '{$1=$1};1')

styled_output=$(gum style --foreground 10 "+$total_files")
echo "$styled_output files have been staged."
