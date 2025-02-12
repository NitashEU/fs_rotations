#!/bin/bash

# Check if files and message are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 \"<commit-message>\" <file1> [file2 ...]"
    echo "Example: $0 \"feat: add new healing logic\" classes/paladin/holy/logic/healing.lua"
    exit 1
fi

# Extract commit message (first argument)
commit_msg="$1"
shift

# Validate commit message format
prefix_pattern="^(feat|fix|perf|docs|style|refactor|test|chore):"
if ! echo "$commit_msg" | grep -qE "$prefix_pattern"; then
    echo "Error: Commit message must start with one of: feat:, fix:, perf:, docs:, style:, refactor:, test:, chore:"
    exit 1
fi

# Check for uppercase in first line
if echo "$commit_msg" | head -n 1 | grep -q "[A-Z]"; then
    echo "Error: Commit message must be lowercase"
    exit 1
fi

# Get commit type
commit_type=$(echo "$commit_msg" | grep -oE '^(feat|fix|perf|docs|style|refactor|test|chore):' | sed 's/://')

# Get repository root
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Extract current version from header.lua before any changes
current_version=$(grep 'version = ".*"' "$REPO_ROOT/header.lua" | head -n 1 | sed 's/.*version = "\(.*\)".*/\1/')

# Stage the specified files first
for file in "$@"; do
    if [ -f "$file" ]; then
        git add "$file"
        echo "Staged: $file"
    else
        echo "Warning: File not found: $file"
    fi
done

# Only proceed with version bump for specific types
if [[ $commit_type =~ ^(feat|fix|perf|refactor)$ ]]; then
    # Split version into components
    IFS='.' read -r major minor patch <<< "$current_version"

    # Determine version bump type based on commit type
    if [[ $commit_type == "feat" ]]; then
        new_minor=$((minor + 1))
        new_version="$major.$new_minor.0"
    else
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
    fi

    echo "Current version: $current_version"
    echo "New version will be: $new_version"

    # Update version in header.lua (both occurrences)
    sed -i "s/version = \"$current_version\"/version = \"$new_version\"/" "$REPO_ROOT/header.lua"

    # Update version in README.md
    sed -i "s/Current Version: $current_version/Current Version: $new_version/" "$REPO_ROOT/README.md"

    # Stage the version files
    git add "$REPO_ROOT/header.lua" "$REPO_ROOT/README.md"

    # Prepare version bump message
    version_info="Version bump: $current_version → $new_version"
else
    echo "Commit type $commit_type will not trigger version bump"
fi

# Prepare full commit message
if [[ $commit_type =~ ^(feat|fix|perf|refactor)$ ]]; then
    full_commit_msg="${commit_msg}

${version_info}"
else
    full_commit_msg="$commit_msg"
fi

# Add [no-ref] if no issue reference is present
if ! echo "$full_commit_msg" | grep -qE "(#[0-9]+|GH-[0-9]+)"; then
    full_commit_msg="${full_commit_msg} [no-ref]"
fi

# Create commit
git commit -m "$full_commit_msg"

# Show summary
echo "Commit successful!"
if [[ $commit_type =~ ^(feat|fix|perf|refactor)$ ]]; then
    echo "$version_info"
fi

exit 0