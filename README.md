# Lab10 Multiplataforma — Prime Video móvil (Flutter)

## Estructura

```
assets/
  fonts/            BebasNeue, Montserrat, Inter (3 tipos de letra)
  images/           avatar local
  images/posters/   portadas locales (se descargan con tools/descargar_posters.ps1)
lib/
  main.dart
  data/       catalogo.dart (títulos reales: portadas locales + en la nube)
  models/     contenido.dart, perfil.dart
  services/   estado_usuario.dart, mi_lista_service.dart
  theme/      app_theme.dart
  widgets/    carrusel, tarjetas, vista previa, shimmer, presionable, avatar, imagen local/nube, Mi lista, ruleta
  screens/    splash, perfiles, inicio, ver todo, buscar, mi lista, mi espacio, detalle, reproductor
tools/
  descargar_posters.ps1
test/
```

## Cómo iniciarlo

```powershell
git clone https://github.com/pabloislaarone/lab10-multiplataforma.git
cd lab10-multiplataforma
powershell -ExecutionPolicy Bypass -File tools\descargar_posters.ps1
flutter create . --project-name prime_video_movil --platforms android,ios,web
flutter pub get
flutter run
```
