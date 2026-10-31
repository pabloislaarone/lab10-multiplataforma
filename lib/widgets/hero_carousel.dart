import 'dart:async';

import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/app_theme.dart';
import 'boton_mi_lista.dart';
import 'imagen_contenido.dart';
import 'tarjetas.dart';

/// Carrusel principal con banners grandes que avanza solo cada 5 s.
class HeroCarousel extends StatefulWidget {
  final List<Contenido> items;
  const HeroCarousel({super.key, required this.items});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final _controller = PageController();
  int _actual = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_controller.hasClients) return;
      final siguiente = (_actual + 1) % widget.items.length;
      _controller.animateToPage(
        siguiente,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.width * 1.05;
    return SizedBox(
      height: alto,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _actual = i),
            itemBuilder: (_, i) => _Banner(contenido: widget.items[i]),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (i) {
                final activo = i == _actual;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: activo ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: activo ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final Contenido contenido;
  const _Banner({required this.contenido});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => abrirDetalle(context, contenido, heroPrefijo: 'banner'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'banner-${contenido.id}',
            child: ImagenContenido(
              ruta: contenido.imagenHorizontal,
              wiki: contenido.wiki,
              alignment: Alignment.topCenter,
              textoRespaldo: contenido.titulo,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xAA0F171E), AppColors.fondo],
                stops: [0.35, 0.7, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (contenido.original)
                  const Text(
                    'PRIME ORIGINAL',
                    style: TextStyle(
                      fontFamily: AppFonts.encabezado,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 2,
                      color: AppColors.azulPrime,
                    ),
                  ),
                Text(
                  contenido.titulo.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: AppFonts.titulo,
                    fontSize: 46,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${contenido.anio} · ${contenido.clasificacion} · ${contenido.duracion} · ${contenido.generos.join(', ')}',
                  style: AppTheme.metadato.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                InsigniaPrime(incluido: contenido.incluidoConPrime),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => abrirDetalle(context, contenido, heroPrefijo: 'banner'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          contenido.progreso > 0 ? 'Continuar' : 'Reproducir',
                          style: const TextStyle(
                            fontFamily: AppFonts.encabezado,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BotonMiLista(contenido: contenido),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
