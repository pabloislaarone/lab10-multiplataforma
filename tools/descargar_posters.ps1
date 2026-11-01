# Descarga las portadas LOCALES (portadas oficiales de primevideo.com,
# fines educativos) a assets/images/posters. Ejecutar desde la raíz:
#   powershell -ExecutionPolicy Bypass -File tools\descargar_posters.ps1

$destino = Join-Path $PSScriptRoot "..\assets\images\posters"
New-Item -ItemType Directory -Force -Path $destino | Out-Null
$cdn = "https://m.media-amazon.com/images/S/pv-target-images"

$portadas = [ordered]@{
  "the_boys"       = "6e28c101c573e81bb2b0045182c575accdcc1105412003662ed610a53309311f"
  "rings_of_power" = "653ef15291b348dd7e364ecb29b1103aa6ae5f575d89457e676e4307d5c48650"
  "reacher"        = "aadd9372f927030570c30da0d93b787f762e6be8646b378fb0713ee14e3b1367"
  "fallout"        = "89431e424bc3c33ebd02e2505471d5e76a4fdbacbbda434e65ca027a0423e2d9"
  "invincible"     = "78afe406779795dfbc13b08845a48edcd88a5deb81130a437b358170a1fa8552"
  "saltburn"       = "5e6e36faf924dfb40910a6598807eb0dd0f4273025fb5783fab4d42d98a72953"
}

foreach ($id in $portadas.Keys) {
  try {
    $url = "$cdn/$($portadas[$id])._UR1920,1080_SX1280_FMjpg_.png"
    Invoke-WebRequest -Uri $url -OutFile (Join-Path $destino "$id.png") -UseBasicParsing
    Write-Host "  [ok] $id"
  } catch {
    Write-Host "  [error] $id -> $($_.Exception.Message)"
  }
}
Write-Host "Listo. Portadas en assets\images\posters"
