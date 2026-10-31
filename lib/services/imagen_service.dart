import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Obtiene la URL del póster de un título desde la API pública de Wikipedia.
/// Guarda en caché el resultado para no repetir la consulta.
class ImagenService {
  ImagenService._();

  static final Map<String, Future<String?>> _cache = {};

  /// Wikipedia pide un User-Agent descriptivo (en web el navegador pone el suyo).
  static Map<String, String> get cabeceras => kIsWeb
      ? const {}
      : const {'User-Agent': 'Lab10PrimeVideoMovil/1.0 (proyecto educativo TECSUP)'};

  static Future<String?> urlPoster(String tituloWiki) =>
      _cache.putIfAbsent(tituloWiki, () => _consultar(tituloWiki));

  static Future<String?> _consultar(String tituloWiki) async {
    try {
      final uri = Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(tituloWiki)}',
      );
      final resp = await http.get(uri, headers: cabeceras).timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) {
        _cache.remove(tituloWiki); // permitir reintento
        return null;
      }
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final original = json['originalimage'] as Map<String, dynamic>?;
      final miniatura = json['thumbnail'] as Map<String, dynamic>?;
      return (original?['source'] ?? miniatura?['source']) as String?;
    } catch (_) {
      _cache.remove(tituloWiki);
      return null;
    }
  }
}
