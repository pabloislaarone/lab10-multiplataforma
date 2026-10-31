import 'package:flutter/material.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../theme/app_theme.dart';
import '../widgets/tarjetas.dart';

/// MEJORA: búsqueda en tiempo real con filtros por tipo, género
/// y "solo incluido con Prime".
class BuscarScreen extends StatefulWidget {
  const BuscarScreen({super.key});

  @override
  State<BuscarScreen> createState() => _BuscarScreenState();
}

class _BuscarScreenState extends State<BuscarScreen> {
  final _texto = TextEditingController();
  TipoContenido? _tipo;
  String? _genero;
  bool _soloPrime = false;

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  bool get _hayFiltros =>
      _texto.text.trim().isNotEmpty || _tipo != null || _genero != null || _soloPrime;

  List<Contenido> get _resultados {
    final q = _quitarTildes(_texto.text.trim().toLowerCase());
    return catalogo.where((c) {
      final coincideTexto = q.isEmpty ||
          _quitarTildes(c.titulo.toLowerCase()).contains(q) ||
          c.generos.any((g) => _quitarTildes(g.toLowerCase()).contains(q));
      final coincideTipo = _tipo == null || c.tipo == _tipo;
      final coincideGenero = _genero == null || c.generos.contains(_genero);
      final coincidePrime = !_soloPrime || c.incluidoConPrime;
      return coincideTexto && coincideTipo && coincideGenero && coincidePrime;
    }).toList();
  }

  static String _quitarTildes(String s) {
    const con = 'áéíóúüñ';
    const sin = 'aeiouun';
    var r = s;
    for (var i = 0; i < con.length; i++) {
      r = r.replaceAll(con[i], sin[i]);
    }
    return r;
  }

  void _limpiar() {
    setState(() {
      _texto.clear();
      _tipo = null;
      _genero = null;
      _soloPrime = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar',
          style: TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w800),
        ),
        actions: [
          if (_hayFiltros)
            TextButton(onPressed: _limpiar, child: const Text('Limpiar')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _texto,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontFamily: AppFonts.cuerpo),
              decoration: InputDecoration(
                hintText: 'Películas, series, géneros…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _texto.text.isEmpty
                    ? const Icon(Icons.mic_none)
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(_texto.clear),
                      ),
                filled: true,
                fillColor: AppColors.superficieAlta,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: const Text('Incluido con Prime'),
                  avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.azulPrime),
                  selected: _soloPrime,
                  showCheckmark: false,
                  onSelected: (v) => setState(() => _soloPrime = v),
                ),
                const SizedBox(width: 8),
                _chipTipo('Películas', TipoContenido.pelicula),
                _chipTipo('Series', TipoContenido.serie),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: todosLosGeneros
                  .map((g) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(g),
                          selected: _genero == g,
                          showCheckmark: false,
                          onSelected: (v) => setState(() => _genero = v ? g : null),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: !_hayFiltros
                ? _explorarGeneros()
                : resultados.isEmpty
                    ? const Center(
                        child: Text('Sin resultados 😕', style: AppTheme.tituloSeccion),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2 / 3,
                        ),
                        itemCount: resultados.length,
                        itemBuilder: (_, i) =>
                            PosterCard(contenido: resultados[i], heroPrefijo: 'buscar'),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _chipTipo(String texto, TipoContenido tipo) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(texto),
          selected: _tipo == tipo,
          showCheckmark: false,
          onSelected: (v) => setState(() => _tipo = v ? tipo : null),
        ),
      );

  Widget _explorarGeneros() {
    const colores = [
      Color(0xFF0F79AF),
      Color(0xFF7B2CBF),
      Color(0xFFD62828),
      Color(0xFF2A9D8F),
      Color(0xFFF77F00),
      Color(0xFF3A0CA3),
    ];
    final generos = todosLosGeneros;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: generos.length,
      itemBuilder: (_, i) => InkWell(
        onTap: () => setState(() => _genero = generos[i]),
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [colores[i % colores.length], AppColors.superficieAlta],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                generos[i].toUpperCase(),
                style: const TextStyle(fontFamily: AppFonts.titulo, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
