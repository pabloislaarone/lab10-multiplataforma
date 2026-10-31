import 'package:flutter_test/flutter_test.dart';
import 'package:prime_video_movil/data/catalogo.dart';

void main() {
  test('El catálogo mezcla imágenes locales y de la nube', () {
    expect(catalogo.any((c) => c.esImagenLocal), isTrue);
    expect(catalogo.any((c) => !c.esImagenLocal), isTrue);
  });

  test('El Top 10 está ordenado por calificación', () {
    final top = top10;
    for (var i = 0; i < top.length - 1; i++) {
      expect(top[i].calificacion >= top[i + 1].calificacion, isTrue);
    }
  });
}
