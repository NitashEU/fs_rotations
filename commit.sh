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

# Extract current version components from version.lua
version_file="$REPO_ROOT/version.lua"
current_major=$(grep 'major = ' "$version_file" | head -n 1 | sed 's/.*major = \([0-9]*\).*/\1/')
current_minor=$(grep 'minor = ' "$version_file" | head -n 1 | sed 's/.*minor = \([0-9]*\).*/\1/')
current_patch=$(grep 'patch = ' "$version_file" | head -n 1 | sed 's/.*patch = \([0-9]*\).*/\1/')
current_version="$current_major.$current_minor.$current_patch"

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
    # Calculate new version
    if [[ $commit_type == "feat" ]]; then
        new_minor=$((current_minor + 1))
        new_patch=0
        new_version="$current_major.$new_minor.$new_patch"
    else
        new_patch=$((current_patch + 1))
        new_version="$current_major.$current_minor.$new_patch"
    fi

    echo "Current version: $current_version"
    echo "New version will be: $new_version"

    # Update version.lua file
    if [[ $commit_type == "feat" ]]; then
        sed -i "s/minor = $current_minor/minor = $new_minor/" "$version_file"
        sed -i "s/patch = $current_patch/patch = 0/" "$version_file"
    else
        sed -i "s/patch = $current_patch/patch = $new_patch/" "$version_file"
    fi

    # Update version in README.md
    sed -i "s/Current Version: $current_version/Current Version: $new_version/" "$REPO_ROOT/README.md"

    # Update CHANGELOG.md
    changelog_file="$REPO_ROOT/CHANGELOG.md"
    today=$(date +%Y-%m-%d)
    
    # Check if version section exists, if not create it
    if ! grep -q "## \[$new_version\]" "$changelog_file"; then
        # Insert new version section after the header line
        sed -i "3a\\\n## [$new_version] - $today\n" "$changelog_file"
    fi
    
    # Add entry under appropriate category
    case "$commit_type" in
        feat)
            section="### Added"
            ;;
        fix)
            section="### Fixed"
            ;;
        perf)
            section="### Performance"
            ;;
        refactor)
            section="### Changed"
            ;;
    esac
    
    # Check if section exists within current version, if not create it
    if ! grep -A20 "## \[$new_version\]" "$changelog_file" | grep -q "$section"; then
        # Find the line with version header and insert section after it
        line_number=$(grep -n "## \[$new_version\]" "$changelog_file" | cut -d: -f1)
        sed -i "${line_number}a\\$section" "$changelog_file"
    fi
    
    # Add commit message to section (clean it up by removing the prefix)
    clean_message=$(echo "$commit_msg" | sed "s/^$commit_type: //")
    
    # Find the section within the current version
    section_line=$(grep -A20 "## \[$new_version\]" "$changelog_file" | grep -n "$section" | head -1 | cut -d: -f1)
    if [ -n "$section_line" ]; then
        # Calculate absolute line number
        version_line=$(grep -n "## \[$new_version\]" "$changelog_file" | cut -d: -f1)
        absolute_section_line=$((version_line + section_line - 1))
        # Insert entry after the section header
        sed -i "${absolute_section_line}a\\- $clean_message" "$changelog_file"
    fi
    
    # Stage the version files
    git add "$version_file" "$REPO_ROOT/README.md" "$changelog_file"

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