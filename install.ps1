#Requires -RunAsAdministrator
#Requires -Version 6.0

# ------------------------------------------------------------------ Globals -
$scriptDir = Split-Path -Parent $script:MyInvocation.MyCommand.Path
$scriptName = $script:MyInvocation.MyCommand.Name
$sourceDir = Join-Path $scriptDir "src" "scripts"
$targetDir = Join-Path $HOME "bin"

# ---------------------------------------------------------------- Functions -
function info { Write-Output "$scriptName`: $args"}
function eexit { info "Error: $args"; exit 1}

# --------------------------------------------------------------------- Main -
function main
{
    # check requirements
    if (!(Test-Path $sourceDir)) { eexit "directory $sourceDir does not exist." }
    if (!(Test-Path $targetDir)) { eexit "directory $targetDir does not exist." }
    # loop through files
    foreach ($file in (Get-ChildItem -Recurse -File -Filter "*.ps1" $sourceDir)) {
        $sourceFile = $file.FullName
        $targetFile = Join-Path $targetDir $file.Name
        # ignore existing targets
        if (Test-Path $targetFile) { info "$targetFile already exists."; continue }
        # create link (requires elevated persmissions)
        [void](New-Item -ItemType SymbolicLink -Path "$targetFile" -Target "$sourceFile")
        info "$targetFile created."
    }
    info "Done."
}

# ------------------------------------------------------------------ Runtime -
main
exit 0
