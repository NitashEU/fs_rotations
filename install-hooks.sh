#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symbolic links for each hook
for hook in "$SCRIPT_DIR"/git-hooks/*; do
    if [ -f "$hook" ]; then
        # Get just the filename
        hook_name=$(basename "$hook")
        # Create symlink in .git/hooks
        ln -sf "../../git-hooks/$hook_name" "$SCRIPT_DIR/.git/hooks/$hook_name"
        # Make the hook executable
        chmod +x "$SCRIPT_DIR/git-hooks/$hook_name"
        echo "Installed $hook_name hook"
    fi
done

echo "Git hooks installation complete!"