import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../theme/app_theme.dart';
import 'imagen_contenido.dart';
import 'tarjetas.dart';

/// MEJORA: "¿Qué veo hoy?" — ruleta que elige un título al azar
/// (opcionalmente filtrado por género) para quien no sabe qué ver.
void mostrarSorpresa(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.superficie,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const SorpresaSheet(),
  );
}

class SorpresaSheet extends StatefulWidget {
  const SorpresaSheet({super.key});

  @override
  State<SorpresaSheet> createState() => _SorpresaSheetState();
}

class _SorpresaSheetState extends State<SorpresaSheet> {
  final _random = Random();
  String? _genero; // null = cualquiera
  Contenido? _actual;
  bool _girando = false;
  Timer? _timer;

  List<Contenido> get _candidatos => _genero == null
      ? contenidosVisibles
      : contenidosVisibles.where((c) => c.generos.contains(_genero)).toList();

  @override
  void initState() {
    super.initState();
    _girar();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _girar() {
    final lista = _candidatos;
    if (lista.isEmpty) return;
    _timer?.cancel();
    setState(() => _girando = true);
    var vueltas = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      vueltas++;
      setState(() => _actual = lista[_random.nextInt(lista.length)]);
      if (vueltas >= 14) {
        t.cancel();
        setState(() => _girando = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = _actual;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              '¿QUÉ VEO HOY?',
              style: TextStyle(fontFamily: AppFonts.titulo, fontSize: 34, letterSpacing: 1),
            ),
            const Text(
              'Elige un género o déjalo a la suerte',
              style: AppTheme.metadato,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chipGenero(null, 'Sorpréndeme'),
                  ...todosLosGeneros.map((g) => _chipGenero(g, g)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (c != null)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 120),
                child: Row(
                  key: ValueKey(c.id),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ImagenContenido(
                        ruta: c.imagen,
                        wiki: c.wiki,
                        width: 110,
                        height: 165,
                        textoRespaldo: c.titulo,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.titulo,
                            style: const TextStyle(
                              fontFamily: AppFonts.encabezado,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${c.tipoTexto} · ${c.anio} · ⭐ ${c.calificacion}',
                            style: AppTheme.metadato,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            c.descripcion,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _girando ? null : _girar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Otra vez'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _girando || c == null
                        ? null
                        : () {
                            Navigator.pop(context);
                            abrirDetalle(context, c, heroPrefijo: 'sorpresa');
                          },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Ver ahora'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.azulPrime,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipGenero(String? valor, String texto) {
    final activo = _genero == valor;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: activo,
        showCheckmark: false,
        onSelected: (_) {
          setState(() => _genero = valor);
          _girar();
        },
      ),
    );
  }
}
