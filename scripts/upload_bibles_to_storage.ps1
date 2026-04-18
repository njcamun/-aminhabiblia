param(
  [string]$Bucket = 'gs://aminhabiblia-558d1.firebasestorage.app'
)

$ErrorActionPreference = 'Stop'

$files = @(
  'ACF.json',
  'ARA.json',
  'ARC.json',
  'KJF.json',
  'NVI.json',
  'NVT.json',
  'NTLH.json'
)

foreach ($file in $files) {
  $localPath = Join-Path $PSScriptRoot "..\assets\biblias\$file"
  if (-not (Test-Path $localPath)) {
    throw "File not found: $localPath"
  }

  $remotePath = "$Bucket/bibles/$file"
  Write-Host "Uploading $file -> $remotePath"
  gcloud storage cp $localPath $remotePath
}

Write-Host 'Upload concluido com sucesso.'
