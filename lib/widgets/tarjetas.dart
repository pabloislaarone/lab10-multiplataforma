import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/contenido.dart';
import '../screens/detalle_screen.dart';
import '../screens/reproductor_screen.dart';
import '../services/estado_usuario.dart';
import '../theme/app_theme.dart';
import 'imagen_contenido.dart';
import 'vista_previa_sheet.dart';

void abrirDetalle(BuildContext context, Contenido c, {String heroPrefijo = ''}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => DetalleScreen(contenido: c, heroPrefijo: heroPrefijo),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    ),
  );
}

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

/// Póster vertical (2:3).
class PosterCard extends StatelessWidget {
  final Contenido contenido;
  final double ancho;
  final String heroPrefijo;

  const PosterCard({
    super.key,
    required this.contenido,
    this.ancho = 120,
    this.heroPrefijo = 'poster',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => abrirDetalle(context, contenido, heroPrefijo: heroPrefijo),
      onLongPress: () => mostrarVistaPrevia(context, contenido),
      child: SizedBox(
        width: ancho,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: '$heroPrefijo-${contenido.id}',
                  child: ImagenContenido(
                    ruta: contenido.imagen,
                    wiki: contenido.wiki,
                    textoRespaldo: contenido.titulo,
                  ),
                ),
                if (contenido.original)
                  const Positioned(top: 6, left: 6, child: _EtiquetaOriginal()),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(170),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      contenido.incluidoConPrime ? Icons.check : Icons.attach_money,
                      size: 12,
                      color: contenido.incluidoConPrime
                          ? AppColors.azulPrime
                          : AppColors.dorado,
                    ),
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

class _EtiquetaOriginal extends StatelessWidget {
  const _EtiquetaOriginal();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.azulPrime,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        'ORIGINAL',
        style: TextStyle(
          fontFamily: AppFonts.encabezado,
          fontWeight: FontWeight.w800,
          fontSize: 8,
          letterSpacing: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Tarjeta horizontal (16:9) con barra de progreso para "Continuar viendo".
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
    return GestureDetector(
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
                    Hero(
                      tag: 'continuar-${contenido.id}',
                      child: ImagenContenido(
                        ruta: contenido.imagenHorizontal,
                        wiki: contenido.wiki,
                        textoRespaldo: contenido.titulo,
                      ),
                    ),
                    Container(color: Colors.black.withAlpha(60)),
                    const Center(
                      child: Icon(Icons.play_circle_fill, size: 44, color: Colors.white),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        value: progreso,
                        minHeight: 4,
                        backgroundColor: Colors.white24,
                        color: AppColors.azulPrime,
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

/// Tarjeta del Top 10 con número gigante en BebasNeue.
class TarjetaTop extends StatelessWidget {
  final Contenido contenido;
  final int posicion;
  const TarjetaTop({super.key, required this.contenido, required this.posicion});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: -18,
            child: Text(
              '$posicion',
              style: TextStyle(
                fontFamily: AppFonts.titulo,
                fontSize: 130,
                height: 1,
                color: AppColors.fondo,
                shadows: const [
                  Shadow(color: AppColors.azulPrime, blurRadius: 0, offset: Offset(1.5, 1.5)),
                  Shadow(color: AppColors.azulPrime, blurRadius: 0, offset: Offset(-1.5, -1.5)),
                  Shadow(color: AppColors.azulPrime, blurRadius: 0, offset: Offset(1.5, -1.5)),
                  Shadow(color: AppColors.azulPrime, blurRadius: 0, offset: Offset(-1.5, 1.5)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: PosterCard(contenido: contenido, ancho: 115, heroPrefijo: 'top'),
          ),
        ],
      ),
    );
  }
}
