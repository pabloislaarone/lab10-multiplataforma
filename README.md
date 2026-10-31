# Lab10 Multiplataforma — Prime Video móvil (Flutter)

## Estructura

```
assets/
  fonts/            BebasNeue, Montserrat, Inter (3 tipos de letra)
  images/           avatar local
  images/posters/   pósters locales (se descargan con tools/descargar_posters.ps1)
lib/
  main.dart
  data/       catalogo.dart (títulos reales: pósters locales + en la nube)
  models/     contenido.dart
  services/   mi_lista_service.dart, imagen_service.dart
  theme/      app_theme.dart
  widgets/    carrusel, tarjetas, imagen local/nube, botón Mi lista, ruleta "¿Qué veo hoy?"
  screens/    splash, inicio, buscar, mi lista, mi espacio, detalle, reproductor
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
