import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/contenido.dart';
import '../screens/detalle_screen.dart';
import '../screens/reproductor_screen.dart';
import '../services/estado_usuario.dart';
import '../theme/app_theme.dart';
import 'imagen_contenido.dart';
import 'presionable.dart';
import 'vista_previa_sheet.dart';

/// Abre el detalle con una transición suave (fundido + leve subida),
/// mientras la portada viaja con Hero.
void abrirDetalle(BuildContext context, Contenido c, {String heroPrefijo = ''}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, __, ___) => DetalleScreen(contenido: c, heroPrefijo: heroPrefijo),
      transitionsBuilder: (_, anim, __, child) {
        final curva = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curva,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(curva),
            child: child,
          ),
        );
      },
    ),
  );
}

/// Hero de la portada: la imagen "vuela" de la tarjeta al detalle.
Widget heroPortada({required String tag, required Widget child}) => Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: child,
    );

/// Insignia azul "Incluido con Prime" o "Alquilar".
class InsigniaPrime extends StatelessWidget {
  final bool incluido;
  const InsigniaPrime({super.key, required this.incluido});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          incluido ? Icons.check_circle : Icons.shopping_bag_outlined,
          size: 14,
          color: incluido ? AppColors.azulPrime : AppColors.dorado,
        ),
        const SizedBox(width: 4),
        Text(
          incluido ? 'Incluido con Prime' : 'Alquilar o comprar',
          style: TextStyle(
            fontFamily: AppFonts.cuerpo,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: incluido ? AppColors.azulPrime : AppColors.dorado,
          ),
        ),
      ],
    );
  }
}

/// Tarjeta horizontal 16:9, como las filas de la app móvil de Prime Video.
/// Toque: abre el detalle. Mantener presionado: vista previa.
class PosterCard extends StatelessWidget {
  final Contenido contenido;
  final double ancho;
  final String heroPrefijo;

  const PosterCard({
    super.key,
    required this.contenido,
    this.ancho = 200,
    this.heroPrefijo = 'poster',
  });

  @override
  Widget build(BuildContext context) {
    return Presionable(
      onTap: () => abrirDetalle(context, contenido, heroPrefijo: heroPrefijo),
      onLongPress: () => mostrarVistaPrevia(context, contenido),
      child: SizedBox(
        width: ancho,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                heroPortada(
                  tag: '$heroPrefijo-${contenido.id}',
                  child: ImagenContenido(
                    ruta: contenido.imagen,
                    respaldo: contenido.imagenNube,
                    textoRespaldo: contenido.titulo,
                  ),
                ),
                if (!contenido.incluidoConPrime)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.attach_money, size: 12, color: AppColors.dorado),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de "Continuar viendo": reproduce directo y muestra la barra de progreso.
class TarjetaContinuar extends StatelessWidget {
  final Contenido contenido;
  const TarjetaContinuar({super.key, required this.contenido});

  @override
  Widget build(BuildContext context) {
    final estado = EstadoUsuario.instancia;
    final progreso = estado.progresoDe(contenido.id);
    final detalle = contenido.tipo == TipoContenido.serie
        ? 'T1:E${estado.episodioDe(contenido.id)}'
        : contenido.tipoTexto;
    return Presionable(
      onTap: () => abrirReproductor(context, contenido),
      onLongPress: () {
        HapticFeedback.mediumImpact();
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.superficie,
          builder: (sheetCtx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Ver detalles'),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    abrirDetalle(context, contenido, heroPrefijo: 'continuar');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Quitar de Continuar viendo'),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    estado.quitarDeContinuar(contenido.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    heroPortada(
                      tag: 'continuar-${contenido.id}',
                      child: ImagenContenido(
                        ruta: contenido.imagen,
                        respaldo: contenido.imagenNube,
                        textoRespaldo: contenido.titulo,
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 8,
                      bottom: 10,
                      child: Icon(Icons.play_circle_fill, size: 32, color: Colors.white),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progreso),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, __) => LinearProgressIndicator(
                          value: v,
                          minHeight: 4,
                          backgroundColor: Colors.white24,
                          color: AppColors.azulPrime,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              contenido.titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppFonts.encabezado,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            Text(
              '$detalle · Queda ${((1 - progreso) * 100).round()}%',
              style: AppTheme.metadato,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta del Top 10 con número gigante en BebasNeue y portada 16:9.
class TarjetaTop extends StatelessWidget {
  final Contenido contenido;
  final int posicion;
  const TarjetaTop({super.key, required this.contenido, required this.posicion});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 62,
            child: Text(
              '$posicion',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.titulo,
                fontSize: 110,
                height: 0.82,
                color: AppColors.fondo,
                shadows: [
                  Shadow(color: AppColors.azulPrime, offset: Offset(1.5, 1.5)),
                  Shadow(color: AppColors.azulPrime, offset: Offset(-1.5, -1.5)),
                  Shadow(color: AppColors.azulPrime, offset: Offset(1.5, -1.5)),
                  Shadow(color: AppColors.azulPrime, offset: Offset(-1.5, 1.5)),
                ],
              ),
            ),
          ),
          Expanded(child: PosterCard(contenido: contenido, ancho: 178, heroPrefijo: 'top')),
        ],
      ),
    );
  }
}
