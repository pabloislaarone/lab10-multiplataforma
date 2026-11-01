import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/contenido.dart';
import '../screens/reproductor_screen.dart';
import '../services/estado_usuario.dart';
import '../theme/app_theme.dart';
import 'boton_mi_lista.dart';
import 'imagen_contenido.dart';
import 'tarjetas.dart';

/// Vista previa rápida al mantener presionado un póster (como en las apps
/// de streaming): reproducir, tráiler, Mi lista, me gusta y ver detalles.
void mostrarVistaPrevia(BuildContext context, Contenido c) {
  HapticFeedback.mediumImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.superficie,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (sheetCtx) => _VistaPrevia(contenido: c, contextoPadre: context),
  );
}

class _VistaPrevia extends StatelessWidget {
  final Contenido contenido;
  final BuildContext contextoPadre;
  const _VistaPrevia({required this.contenido, required this.contextoPadre});

  @override
  Widget build(BuildContext context) {
    final c = contenido;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImagenContenido(
                    ruta: c.imagen,
                    respaldo: c.imagenNube,
                    width: 128,
                    height: 72,
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
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${c.anio} · ${c.clasificacion} · ${c.duracion}',
                        style: AppTheme.metadato,
                      ),
                      const SizedBox(height: 4),
                      InsigniaPrime(incluido: c.incluidoConPrime),
                      const SizedBox(height: 8),
                      Text(
                        c.descripcion,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.35),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textoSecundario),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  abrirReproductor(contextoPadre, c);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.azulPrime,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  EstadoUsuario.instancia.progresoDe(c.id) > 0 ? 'Continuar viendo' : 'Reproducir',
                  style: const TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListenableBuilder(
              listenable: EstadoUsuario.instancia,
              builder: (_, __) {
                final valor = EstadoUsuario.instancia.valoracionDe(c.id);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Boton(
                      icono: Icons.movie_outlined,
                      texto: 'Tráiler',
                      onTap: () {
                        Navigator.pop(context);
                        abrirReproductor(contextoPadre, c, trailer: true);
                      },
                    ),
                    BotonMiLista(contenido: c, conTexto: true),
                    _Boton(
                      icono: valor == 1 ? Icons.thumb_up : Icons.thumb_up_outlined,
                      texto: 'Me gusta',
                      activo: valor == 1,
                      onTap: () => EstadoUsuario.instancia.valorar(c.id, 1),
                    ),
                    _Boton(
                      icono: Icons.info_outline,
                      texto: 'Detalles',
                      onTap: () {
                        Navigator.pop(context);
                        abrirDetalle(contextoPadre, c, heroPrefijo: 'preview');
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Boton extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final bool activo;
  const _Boton({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.activo = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: activo ? AppColors.azulPrime : Colors.white),
            const SizedBox(height: 4),
            Text(texto, style: const TextStyle(fontFamily: AppFonts.cuerpo, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
