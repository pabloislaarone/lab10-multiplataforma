import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';

/// "Mi lista" de cada perfil, guardada en el dispositivo (shared_preferences).
class MiListaService extends ChangeNotifier {
  MiListaService._();
  static final MiListaService instancia = MiListaService._();

  String _perfilId = 'pablo';
  final List<String> _ids = [];

  String get _clave => '${_perfilId}_mi_lista_ids';

  List<Contenido> get contenidos => _ids
      .map((id) => catalogo.where((c) => c.id == id))
      .where((r) => r.isNotEmpty)
      .map((r) => r.first)
      .toList();

  bool contiene(String id) => _ids.contains(id);

  Future<void> cargar(String perfilId) async {
    _perfilId = perfilId;
    final prefs = await SharedPreferences.getInstance();
    _ids
      ..clear()
      ..addAll(prefs.getStringList(_clave) ?? []);
    notifyListeners();
  }

  /// Devuelve true si quedó agregado, false si se quitó.
  Future<bool> alternar(String id) async {
    final agregado = !_ids.contains(id);
    if (agregado) {
      _ids.insert(0, id);
    } else {
      _ids.remove(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_clave, _ids);
    return agregado;
  }
}
