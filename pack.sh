#!/bin/bash

# Create temp directory for staging
tempDir="temp_pack"
mkdir -p "$tempDir"

# Copy required directories preserving structure
for dir in "classes" "core" "entry"; do
    cp -r "$dir" "$tempDir/"
done

# Copy root lua files
cp header.lua "$tempDir/"
cp main.lua "$tempDir/"

# Create archive
cd "$tempDir" && tar -czf ../fs_rotations.tar.gz * && cd ..

# Clean up temp directory
rm -rf "$tempDir"

echo "Package created successfully as fs_rotations.tar.gz"