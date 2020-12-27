Get-ChildItem env:

# Extract version
$my_version = $env:GITHUB_REF -replace "refs/tags/v",""
Write-Output "MY_VERSION=$my_version" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
