import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/contenido.dart';
import '../screens/reproductor_screen.dart';
import '../services/estado_usuario.dart';
import '../theme/app_theme.dart';
import 'boton_mi_lista.dart';
import 'imagen_contenido.dart';
import 'tarjetas.dart';

/// Carrusel principal estilo Prime Video:
/// - avanza solo cada 6 s y se pausa mientras el usuario lo toca
/// - efecto parallax al deslizar y zoom lento ("Ken Burns") en la portada
/// - barra de progreso del banner actual
class HeroCarousel extends StatefulWidget {
  final List<Contenido> items;
  const HeroCarousel({super.key, required this.items});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> with SingleTickerProviderStateMixin {
  static const _intervalo = Duration(seconds: 6);

  final _controller = PageController();
  late final AnimationController _avance = AnimationController(vsync: this, duration: _intervalo)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) _siguiente();
    })
    ..forward();
  int _actual = 0;
  double _pagina = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _pagina = _controller.page ?? 0));
  }

  void _siguiente() {
    if (!_controller.hasClients || widget.items.length < 2) return;
    final destino = (_actual + 1) % widget.items.length;
    if (destino == 0) {
      _controller.jumpToPage(0);
    } else {
      _controller.animateToPage(
        destino,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _pausar() => _avance.stop();
  void _reanudar() => _avance.forward();

  @override
  void dispose() {
    _avance.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final alto = ancho * 1.08;
    return SizedBox(
      height: alto,
      child: Listener(
        onPointerDown: (_) => _pausar(),
        onPointerUp: (_) => _reanudar(),
        onPointerCancel: (_) => _reanudar(),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.items.length,
              onPageChanged: (i) {
                HapticFeedback.selectionClick();
                setState(() => _actual = i);
                _avance.forward(from: 0);
              },
              itemBuilder: (_, i) => _Banner(
                contenido: widget.items[i],
                desplazamiento: (_pagina - i).clamp(-1.0, 1.0),
                activo: i == _actual,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.items.length, (i) {
                  final activo = i == _actual;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: activo ? 26 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.centerLeft,
                    child: activo
                        ? AnimatedBuilder(
                            animation: _avance,
                            builder: (_, __) => FractionallySizedBox(
                              widthFactor: _avance.value,
                              child: Container(color: Colors.white),
                            ),
                          )
                        : null,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final Contenido contenido;
  final double desplazamiento; // -1..1 respecto a la página actual
  final bool activo;
  const _Banner({required this.contenido, required this.desplazamiento, required this.activo});

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final enProgreso = EstadoUsuario.instancia.progresoDe(contenido.id) > 0;
    return GestureDetector(
      onTap: () => abrirDetalle(context, contenido, heroPrefijo: 'banner'),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Parallax: la imagen se mueve más lento que la página.
            Transform.translate(
              offset: Offset(desplazamiento * ancho * 0.35, 0),
              child: TweenAnimationBuilder<double>(
                key: ValueKey('${contenido.id}-$activo'),
                tween: Tween(begin: 1.0, end: activo ? 1.12 : 1.0),
                duration: const Duration(seconds: 7),
                curve: Curves.easeOut,
                builder: (_, escala, child) => Transform.scale(scale: escala, child: child),
                child: heroPortada(
                  tag: 'banner-${contenido.id}',
                  child: ImagenContenido(
                    ruta: contenido.imagenBanner,
                    respaldo: contenido.imagenNubeAncho(1280),
                    textoRespaldo: contenido.titulo,
                  ),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x99000000), Colors.transparent, Color(0xCC0F171E), AppColors.fondo],
                  stops: [0, 0.25, 0.68, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 30,
              child: Opacity(
                opacity: 1 - desplazamiento.abs().clamp(0.0, 1.0),
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
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: AppFonts.titulo,
                        fontSize: 44,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${contenido.anio} · ${contenido.clasificacion} · ${contenido.generos.join(' · ')}',
                      style: AppTheme.metadato.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    InsigniaPrime(incluido: contenido.incluidoConPrime),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => abrirReproductor(context, contenido),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            icon: const Icon(Icons.play_arrow),
                            label: Text(
                              enProgreso ? 'Continuar' : 'Reproducir',
                              style: const TextStyle(
                                fontFamily: AppFonts.encabezado,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        BotonMiLista(contenido: contenido),
                        const SizedBox(width: 6),
                        Material(
                          color: Colors.white.withAlpha(40),
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(Icons.info_outline, color: Colors.white),
                            onPressed: () => abrirDetalle(context, contenido, heroPrefijo: 'banner'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
