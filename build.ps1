$ErrorActionPreference = "Stop"
$wc = [System.Net.WebClient]::new()
$version=(Invoke-Webrequest https://api.github.com/repos/jameswoolfenden/pike/releases/latest|convertfrom-json).name
$pike=get-content -path 'pike.json' |ConvertFrom-Json
$pike.version=$version
$trimmed=$version -replace "v"
$pike.url="https://github.com/JamesWoolfenden/pike/releases/download/$version/pike_$($trimmed)_windows_amd64.zip#/pike.zip"
$FileHash = Get-FileHash -InputStream ($wc.OpenRead($pike.url))
$pike.hash=$FileHash.Hash
$pikeJson =$pike|ConvertTo-Json
Set-Content -Path pike.json -Value $pikeJson