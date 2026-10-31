import 'package:flutter/material.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../theme/app_theme.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/logo_prime.dart';
import '../widgets/seccion_horizontal.dart';
import '../widgets/sorpresa_sheet.dart';
import '../widgets/tarjetas.dart';

enum _Filtro { inicio, peliculas, series }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  double _opacidadBarra = 0;
  _Filtro _filtro = _Filtro.inicio;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final nueva = (_scroll.offset / 220).clamp(0.0, 1.0);
      if ((nueva - _opacidadBarra).abs() > 0.02) {
        setState(() => _opacidadBarra = nueva);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<Contenido> _filtrar(List<Contenido> lista) {
    switch (_filtro) {
      case _Filtro.peliculas:
        return lista.where((c) => c.tipo == TipoContenido.pelicula).toList();
      case _Filtro.series:
        return lista.where((c) => c.tipo == TipoContenido.serie).toList();
      case _Filtro.inicio:
        return lista;
    }
  }

  @override
  Widget build(BuildContext context) {
    final banners = _filtrar(destacados);
    final continuar = _filtrar(continuarViendo);
    final origs = _filtrar(originales);
    final top = _filtrar(top10);
    final incluidos = _filtrar(catalogo.where((c) => c.incluidoConPrime).toList());
    final alquiler = _filtrar(catalogo.where((c) => !c.incluidoConPrime).toList());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.azulPrime,
        foregroundColor: Colors.white,
        onPressed: () => mostrarSorpresa(context),
        icon: const Icon(Icons.casino_outlined),
        label: const Text(
          '¿Qué veo hoy?',
          style: TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              if (banners.isNotEmpty)
                SliverToBoxAdapter(child: HeroCarousel(key: ValueKey(_filtro), items: banners)),
              if (banners.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.top + 110),
                ),
              if (continuar.isNotEmpty)
                SliverToBoxAdapter(
                  child: SeccionHorizontal(
                    titulo: 'Continuar viendo',
                    alto: 175,
                    cantidad: continuar.length,
                    itemBuilder: (_, i) => TarjetaContinuar(contenido: continuar[i]),
                  ),
                ),
              if (origs.isNotEmpty)
                SliverToBoxAdapter(
                  child: SeccionHorizontal(
                    titulo: 'Originales de Prime',
                    subtitulo: 'Solo disponibles aquí',
                    alto: 180,
                    cantidad: origs.length,
                    itemBuilder: (_, i) =>
                        PosterCard(contenido: origs[i], heroPrefijo: 'orig'),
                  ),
                ),
              if (top.isNotEmpty)
                SliverToBoxAdapter(
                  child: SeccionHorizontal(
                    titulo: 'Top 10 en Perú hoy',
                    alto: 175,
                    separacion: 4,
                    cantidad: top.length,
                    itemBuilder: (_, i) => TarjetaTop(contenido: top[i], posicion: i + 1),
                  ),
                ),
              if (incluidos.isNotEmpty)
                SliverToBoxAdapter(
                  child: SeccionHorizontal(
                    titulo: 'Incluido con Prime',
                    alto: 180,
                    cantidad: incluidos.length,
                    itemBuilder: (_, i) =>
                        PosterCard(contenido: incluidos[i], heroPrefijo: 'incl'),
                  ),
                ),
              if (alquiler.isNotEmpty)
                SliverToBoxAdapter(
                  child: SeccionHorizontal(
                    titulo: 'Alquiler o compra',
                    subtitulo: 'Estrenos recientes',
                    alto: 180,
                    cantidad: alquiler.length,
                    itemBuilder: (_, i) =>
                        PosterCard(contenido: alquiler[i], heroPrefijo: 'alq'),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          _barraSuperior(context),
        ],
      ),
    );
  }

  Widget _barraSuperior(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 8, 16, 10),
      decoration: BoxDecoration(
        // BoxDecoration no acepta color y gradient a la vez: se usa uno u otro.
        color: _opacidadBarra < 0.3
            ? null
            : AppColors.fondo.withAlpha((_opacidadBarra * 245).round()),
        gradient: _opacidadBarra < 0.3
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC000000), Colors.transparent],
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LogoPrime(),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.cast, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _chip('Inicio', _Filtro.inicio),
              _chip('Películas', _Filtro.peliculas),
              _chip('Series', _Filtro.series),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String texto, _Filtro filtro) {
    final activo = _filtro == filtro;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() => _filtro = filtro);
          if (_scroll.hasClients) {
            _scroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: activo ? Colors.white : Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontFamily: AppFonts.encabezado,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: activo ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
