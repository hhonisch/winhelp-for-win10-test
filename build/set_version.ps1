#Requires -Version 5

param(
    # Build number
    [int]$BuildNo = 0,
    # Build number offset
    [int]$BuildNoOffset = 0
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


# Set version for WinHelpProxy
function SetVersionWinHelpProxy($ver) {
    Write-Host "Setting version in WinHelpProxy"
    $rcPath = Join-Path $PSScriptRoot "..\src\WinHelpProxy\WinHelpProxy.rc"
    Write-Host "Reading $rcPath..."
    $rcOld = Get-Content $rcPath
    $rcNew = [System.Collections.ArrayList]::new()
    foreach ($line in $rcOld) {
        $line = $line -replace '^(\s*(?:FILE|PRODUCT)VERSION\s+).*$' , "`${1}$($ver.major),$($ver.minor),$($ver.patch),$($ver.build)"
        $line = $line -replace '^(\s*VALUE\s+"(?:File|Product)Version"\s*,\s*).*$' , "`${1}`"$($ver.major).$($ver.minor).$($ver.patch).$($ver.build)`""
        $rcNew.Add($line) | Out-Null
    }
    Write-Host "Writing $rcPath..."
    $rcNew | Out-File $rcPath -Encoding "unicode"
    Write-Host "Done: Setting version in WinHelpProxy"
}



# Set version for Setup
function SetVersionSetup($ver) {
    Write-Host "Setting version in Setup"
    $issPath = Join-Path $PSScriptRoot "..\src\Setup\WinHelp4Win10.iss"
    Write-Host "Reading $issPath..."
    $issOld = Get-Content $issPath
    $issNew = [System.Collections.ArrayList]::new()
    foreach ($line in $issOld) {
        $line = $line -replace '^(\s*#define MyAppVersion\s*).*$' , "`${1}`"$($ver.major).$($ver.minor).$($ver.patch)`""
        $line = $line -replace '^(\s*#define MyBuildNo\s*).*$' , "`${1}`"$($ver.build)`""
        $issNew.Add($line) | Out-Null
    }
    Write-Host "Writing $issPath..."
    $issNew | Out-File $issPath -Encoding "utf8"
    Write-Host "Done: Setting version in Setup"
}




# Main function
function Main() {
    Write-Host "Setting version in application source files"
    $verXmlPath = Join-Path $PSScriptRoot version.xml
    Write-Host "Reading version from $verXmlPath..."
    # Read version from XML file
    [xml] $verXml = Get-Content $verXmlPath
    $verStr = $verXml.version
    Write-Host "  => $verStr"
    $ver = @{"str" = $verStr }
    if ($verStr -match "(\d+)\.(\d+)\.(\d+)") {
        $ver.major = $Matches[1]
        $ver.minor = $Matches[2]
        $ver.patch = $Matches[3]
        $ver.build = $BuildNo + $BuildNoOffset
        $ver.str3 = "$($ver.major).$($ver.minor).$($ver.patch)"
        $ver.str4 = "$($ver.major).$($ver.minor).$($ver.patch).$($ver.build)"
    }
    Write-Host "Setting to: $($ver.str4)"

    
    # Set version for WinHelpProxy
    SetVersionWinHelpProxy $ver

    # Set version for Setup
    SetVersionSetup $ver

    Write-Host "Done: Setting version in application source files"
}


Main