# Descarga los pósters LOCALES (fines educativos) desde Wikipedia
# a assets/images/posters. Ejecutar desde la raíz del proyecto:
#   powershell -ExecutionPolicy Bypass -File tools\descargar_posters.ps1

$ErrorActionPreference = "Stop"
$ua = @{ "User-Agent" = "Lab10PrimeVideoMovil/1.0 (proyecto educativo TECSUP)" }
$destino = Join-Path $PSScriptRoot "..\assets\images\posters"
New-Item -ItemType Directory -Force -Path $destino | Out-Null

$posters = [ordered]@{
  "the_boys"       = "The_Boys_(TV_series)"
  "rings_of_power" = "The_Lord_of_the_Rings:_The_Rings_of_Power"
  "reacher"        = "Reacher_(TV_series)"
  "fallout"        = "Fallout_(American_TV_series)"
  "invincible"     = "Invincible_(TV_series)"
  "saltburn"       = "Saltburn_(film)"
}

foreach ($id in $posters.Keys) {
  try {
    $titulo = [uri]::EscapeDataString($posters[$id])
    $info = Invoke-RestMethod -Uri "https://en.wikipedia.org/api/rest_v1/page/summary/$titulo" -Headers $ua
    $url = if ($info.originalimage) { $info.originalimage.source } else { $info.thumbnail.source }
    if (-not $url) { Write-Host "  [sin imagen] $id"; continue }
    Invoke-WebRequest -Uri $url -Headers $ua -OutFile (Join-Path $destino "$id.jpg")
    Write-Host "  [ok] $id"
  } catch {
    Write-Host "  [error] $id -> $($_.Exception.Message)"
  }
}
Write-Host "Listo. Pósters en assets\images\posters"
