#!/usr/bin/env pwsh
param (
    [Parameter(Mandatory=$true)]
    [string]$Target,
    [string]$Owner="jameswoolfenden"
)

$wc = [System.Net.WebClient]::new()
write-host "Invoke-Webrequest "https://api.github.com/repos/$($Owner)/$Target/releases/latest""
$version=(Invoke-Webrequest "https://api.github.com/repos/$($Owner)/$Target/releases/latest"|convertfrom-json).name
$pike=get-content -path "$($Target).json" |ConvertFrom-Json
$pike.version=$version
$trimmed=$version -replace "v"
$pike.url="https://github.com/$($Owner)/$($Target)/releases/download/$version/$($Target)_$($trimmed)_windows_amd64.zip#/$($Target).zip"
$FileHash = Get-FileHash -InputStream ($wc.OpenRead($pike.url))
$pike.hash=$FileHash.Hash
$pikeJson =$pike|ConvertTo-Json
Set-Content -Path "$($Target).json" -Value $pikeJson