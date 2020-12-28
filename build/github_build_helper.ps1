#Requires -Version 5

param(
    # Command
    [Parameter(Mandatory)]
    [ValidateSet("StoreReleaseMetaInfo", "StoreReleaseNotes")]
    [string] $command
)



# Terminate on exception
trap {
    Write-Host "Error: $_"
    Write-Host $_.ScriptStackTrace
    exit 1
}

# Always stop on errors
$ErrorActionPreference = "Stop"

# Strict mode
Set-StrictMode -Version Latest



# Store release info in dist
function StoreReleaseMetaInfo() {
    Write-Host "Store release meta info"
    $path = Join-Path $PSScriptRoot "..\dist\meta.json"

    # Read version
    $verXmlPath = Join-Path $PSScriptRoot version.xml
    Write-Host "Reading version from $verXmlPath..."
    [xml] $verXml = Get-Content $verXmlPath
    $verStr = $verXml.version

    # Get commit hash
    $commitHash = $env:GITHUB_SHA


    Write-Host "Writing to $path..."
    $json = [ordered]@{ key = "value" ; version = $verStr; commitHash = $commitHash }
    ConvertTo-Json $json | Out-File $path

    Write-Host "Done: Store release meta info"
}


# Store release notes in dist
function StoreReleaseNotes() {
    Write-Host "Store release notes"

    $srcPath = Join-Path $PSScriptRoot "..\RELEASE_NOTES.md"
    $dstPath = Join-Path $PSScriptRoot "..\dist\RELEASE_NOTES.md"
    Write-Host "Reading from $srcPath..."
    Write-Host "Writing to $dstPath..."
    [System.IO.StreamReader] $srcReader = $null
    [System.IO.StreamWriter]  $dstWriter = $null
    try {
        $srcReader = [System.IO.StreamReader]::new($srcPath) 
        $dstWriter = [System.IO.StreamWriter]::new($dstPath)
        while ($srcReader.EndOfStream -eq $false) {
            $line = $srcReader.ReadLine()
            if ($line -match "^\s*--- End of Release Notes ---\s*$") {
                break
            }
            $dstWriter.WriteLine($line)
        }    
    
    }
    finally {
        if ($srcReader) {
            $srcReader.Close()
        }
        if ($dstWriter) {
            $dstWriter.Close()
        }
    }


    Write-Host "Done: Store release notes"
}



# Main function
function Main() {
    if ($command -ieq "StoreReleaseMetaInfo") {
        StoreReleaseMetaInfo
    }
    elseif ($command -ieq "StoreReleaseNotes") {
        StoreReleaseNotes
    }
    else {
        throw "Unkown command: $command"
    }
}


Main











<#
Get-ChildItem env:

# Extract version
$my_version = $env:GITHUB_REF -replace "refs/tags/v",""
Write-Output "MY_VERSION=$my_version" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
#>