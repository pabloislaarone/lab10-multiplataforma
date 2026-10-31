import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../models/perfil.dart';
import 'mi_lista_service.dart';

/// Estado del usuario por perfil: progreso de reproducción, "me gusta",
/// descargas e historial de búsqueda. Todo se guarda en el dispositivo.
class EstadoUsuario extends ChangeNotifier {
  EstadoUsuario._();
  static final EstadoUsuario instancia = EstadoUsuario._();

  Perfil _perfil = perfiles.first;
  Perfil get perfil => _perfil;
  bool get esNinos => _perfil.esNinos;

  final Map<String, double> _progreso = {}; // id -> 0..1
  final Map<String, int> _episodio = {}; // id -> episodio actual (series)
  final List<String> _recientes = []; // ids vistos, más reciente primero
  final Map<String, int> _valoracion = {}; // id -> 1 (me gusta) / -1
  final Map<String, double> _descargas = {}; // id -> 0..1 (1 = completa)
  final List<String> _busquedas = [];
  final Map<String, Timer> _timersDescarga = {};

  String _k(String base) => '${_perfil.id}_$base';

  // ---------------- Perfil ----------------
  Future<void> seleccionarPerfil(Perfil p) async {
    _perfil = p;
    for (final t in _timersDescarga.values) {
      t.cancel();
    }
    _timersDescarga.clear();
    await _cargar();
    await MiListaService.instancia.cargar(p.id);
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    _progreso.clear();
    _episodio.clear();
    _recientes.clear();
    _valoracion.clear();
    _descargas.clear();
    _busquedas.clear();

    final progresoJson = prefs.getString(_k('progreso'));
    if (progresoJson == null && !esNinos) {
      // Primera vez: datos de ejemplo para que "Continuar viendo" no salga vacío.
      for (final c in catalogo.where((c) => c.progreso > 0)) {
        _progreso[c.id] = c.progreso;
        _recientes.add(c.id);
      }
    } else if (progresoJson != null) {
      (jsonDecode(progresoJson) as Map<String, dynamic>)
          .forEach((k, v) => _progreso[k] = (v as num).toDouble());
      _recientes.addAll(prefs.getStringList(_k('recientes')) ?? []);
    }
    final epJson = prefs.getString(_k('episodio'));
    if (epJson != null) {
      (jsonDecode(epJson) as Map<String, dynamic>).forEach((k, v) => _episodio[k] = v as int);
    }
    final valJson = prefs.getString(_k('valoracion'));
    if (valJson != null) {
      (jsonDecode(valJson) as Map<String, dynamic>).forEach((k, v) => _valoracion[k] = v as int);
    }
    for (final id in prefs.getStringList(_k('descargas')) ?? <String>[]) {
      _descargas[id] = 1;
    }
    _busquedas.addAll(prefs.getStringList(_k('busquedas')) ?? []);
    notifyListeners();
  }

  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_k('progreso'), jsonEncode(_progreso));
    await prefs.setStringList(_k('recientes'), _recientes);
    await prefs.setString(_k('episodio'), jsonEncode(_episodio));
    await prefs.setString(_k('valoracion'), jsonEncode(_valoracion));
    await prefs.setStringList(
      _k('descargas'),
      _descargas.entries.where((e) => e.value >= 1).map((e) => e.key).toList(),
    );
    await prefs.setStringList(_k('busquedas'), _busquedas);
  }

  // ---------------- Reproducción ----------------
  double progresoDe(String id) => _progreso[id] ?? 0;
  int episodioDe(String id) => _episodio[id] ?? 1;

  List<Contenido> get continuarViendo => _recientes
      .where((id) => (_progreso[id] ?? 0) > 0.01 && (_progreso[id] ?? 0) < 0.97)
      .map(_buscar)
      .whereType<Contenido>()
      .where((c) => contenidosVisibles.contains(c))
      .toList();

  List<Contenido> get vistosRecientemente =>
      _recientes.map(_buscar).whereType<Contenido>().toList();

  void guardarProgreso(String id, double fraccion, {int? episodio}) {
    _progreso[id] = fraccion.clamp(0.0, 1.0);
    if (episodio != null) _episodio[id] = episodio;
    _recientes
      ..remove(id)
      ..insert(0, id);
    notifyListeners();
    _guardar();
  }

  void quitarDeContinuar(String id) {
    _progreso.remove(id);
    _recientes.remove(id);
    notifyListeners();
    _guardar();
  }

  // ---------------- Me gusta ----------------
  int valoracionDe(String id) => _valoracion[id] ?? 0;

  void valorar(String id, int valor) {
    if (_valoracion[id] == valor) {
      _valoracion.remove(id);
    } else {
      _valoracion[id] = valor;
    }
    notifyListeners();
    _guardar();
  }

  /// Último título marcado con "me gusta" (para recomendaciones).
  Contenido? get ultimoMeGusta {
    final ids = _valoracion.entries.where((e) => e.value == 1).map((e) => e.key).toList();
    if (ids.isEmpty) return null;
    return _buscar(ids.last);
  }

  // ---------------- Descargas (simuladas) ----------------
  double? descargaDe(String id) => _descargas[id];
  List<Contenido> get descargados => _descargas.entries
      .where((e) => e.value >= 1)
      .map((e) => _buscar(e.key))
      .whereType<Contenido>()
      .toList();
  List<MapEntry<Contenido, double>> get descargasEnCurso => _descargas.entries
      .where((e) => e.value < 1)
      .map((e) => MapEntry(_buscar(e.key), e.value))
      .where((e) => e.key != null)
      .map((e) => MapEntry(e.key!, e.value))
      .toList();

  void iniciarDescarga(String id) {
    if (_descargas.containsKey(id)) return;
    _descargas[id] = 0;
    notifyListeners();
    _timersDescarga[id] = Timer.periodic(const Duration(milliseconds: 200), (t) {
      final actual = (_descargas[id] ?? 0) + 0.025;
      if (actual >= 1) {
        _descargas[id] = 1;
        t.cancel();
        _timersDescarga.remove(id);
        _guardar();
      } else {
        _descargas[id] = actual;
      }
      notifyListeners();
    });
  }

  void eliminarDescarga(String id) {
    _timersDescarga.remove(id)?.cancel();
    _descargas.remove(id);
    notifyListeners();
    _guardar();
  }

  // ---------------- Búsquedas ----------------
  List<String> get busquedasRecientes => List.unmodifiable(_busquedas);

  void registrarBusqueda(String texto) {
    final t = texto.trim();
    if (t.isEmpty) return;
    _busquedas
      ..removeWhere((b) => b.toLowerCase() == t.toLowerCase())
      ..insert(0, t);
    if (_busquedas.length > 8) _busquedas.removeLast();
    notifyListeners();
    _guardar();
  }

  void borrarBusquedas() {
    _busquedas.clear();
    notifyListeners();
    _guardar();
  }

  Contenido? _buscar(String id) {
    for (final c in catalogo) {
      if (c.id == id) return c;
    }
    return null;
  }
}
