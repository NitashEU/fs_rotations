################ PowerShell Script ################
$ErrorActionPreference = "Stop"

# Define directories and files to include
$dirsToInclude = @(
    "classes",
    "core",
    "entry"
)

$rootFiles = @(
    "header.lua",
    "main.lua",
    "version.lua"
)

# Create temporary directory structure
$tempDir = "temp_pack"
$fsRotationsDir = Join-Path $tempDir "fs_rotations"

if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $fsRotationsDir | Out-Null

# Copy root files
foreach ($file in $rootFiles) {
    if (Test-Path $file) {
        Copy-Item $file -Destination $fsRotationsDir
        Write-Host "Copied root file: $file"
    }
}

# Copy lua files from directories while preserving structure
foreach ($dir in $dirsToInclude) {
    if (Test-Path $dir) {
        # Create directory in temp folder
        New-Item -ItemType Directory -Path "$fsRotationsDir\$dir" -Force | Out-Null
        
        # Find and copy only .lua files
        Get-ChildItem -Path $dir -Filter "*.lua" -Recurse | ForEach-Object {
            $targetPath = Join-Path $fsRotationsDir $_.FullName.Substring($PWD.Path.Length + 1)
            $targetDir = Split-Path -Parent $targetPath
            
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            
            Copy-Item $_.FullName -Destination $targetPath
        }
        Write-Host "Processed directory: $dir"
    }
}

# Create zip archive
$zipName = "fs_rotations.zip"
if (Test-Path $zipName) {
    Remove-Item -Path $zipName -Force
}

Compress-Archive -Path "$tempDir\*" -DestinationPath $zipName

# Clean up
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Package created successfully: $zipName"
Write-Host "Files are packaged inside 'fs_rotations' directory within the zip"