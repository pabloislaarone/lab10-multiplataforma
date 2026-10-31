# Lab10 Multiplataforma — Prime Video móvil (Flutter)

## Estructura

```
assets/
  fonts/      BebasNeue, Montserrat, Inter (3 tipos de letra)
  images/     pósters, banners y avatar locales
lib/
  main.dart
  data/       catalogo.dart (imágenes locales + en la nube)
  models/     contenido.dart
  services/   mi_lista_service.dart
  theme/      app_theme.dart
  widgets/    carrusel, tarjetas, imagen local/nube, botón Mi lista, ruleta "¿Qué veo hoy?"
  screens/    splash, inicio, buscar, mi lista, mi espacio, detalle, reproductor
test/
```

## Cómo iniciarlo

```bash
git clone https://github.com/pabloislaarone/lab10-multiplataforma.git
cd lab10-multiplataforma
flutter create . --project-name prime_video_movil --platforms android,ios,web
flutter pub get
flutter run
```
