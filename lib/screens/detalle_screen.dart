import 'package:flutter/material.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_mi_lista.dart';
import '../widgets/imagen_contenido.dart';
import '../widgets/tarjetas.dart';
import 'reproductor_screen.dart';

class DetalleScreen extends StatelessWidget {
  final Contenido contenido;
  final String heroPrefijo;
  const DetalleScreen({super.key, required this.contenido, this.heroPrefijo = ''});

  List<Contenido> get _similares => catalogo
      .where((c) => c.id != contenido.id && c.generos.any(contenido.generos.contains))
      .toList();

  void _reproducir(BuildContext context, {String? episodio}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReproductorScreen(contenido: contenido, episodio: episodio),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final c = contenido;
    final ancho = MediaQuery.of(context).size.width;
    final similares = _similares;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: ancho * 9 / 16 + 40,
            pinned: true,
            backgroundColor: AppColors.fondo,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: '$heroPrefijo-${c.id}',
                    child: ImagenContenido(ruta: c.imagenHorizontal, textoRespaldo: c.titulo),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.fondo],
                        stops: [0.55, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (c.original)
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
                    c.titulo.toUpperCase(),
                    style: const TextStyle(fontFamily: AppFonts.titulo, fontSize: 44, height: 1),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.dorado,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'IMDb ${c.calificacion}',
                          style: const TextStyle(
                            fontFamily: AppFonts.encabezado,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text('${c.anio}', style: AppTheme.metadato),
                      Text(c.duracion, style: AppTheme.metadato),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.textoSecundario),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(c.clasificacion, style: AppTheme.metadato),
                      ),
                      const Icon(Icons.hd_outlined, size: 18, color: AppColors.textoSecundario),
                      const Icon(Icons.subtitles_outlined, size: 18, color: AppColors.textoSecundario),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InsigniaPrime(incluido: c.incluidoConPrime),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _reproducir(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.azulPrime,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        c.incluidoConPrime
                            ? (c.progreso > 0 ? 'Continuar viendo' : 'Reproducir')
                            : 'Alquilar desde S/ 14.90',
                        style: const TextStyle(
                          fontFamily: AppFonts.encabezado,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  if (c.progreso > 0) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: c.progreso,
                        minHeight: 3,
                        backgroundColor: Colors.white12,
                        color: AppColors.azulPrime,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Accion(
                        icono: Icons.movie_outlined,
                        texto: 'Tráiler',
                        onTap: () => _reproducir(context, episodio: 'Tráiler oficial'),
                      ),
                      BotonMiLista(contenido: c, conTexto: true),
                      _Accion(
                        icono: Icons.download_outlined,
                        texto: 'Descargar',
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Descargando "${c.titulo}"…')),
                        ),
                      ),
                      _Accion(
                        icono: Icons.share_outlined,
                        texto: 'Compartir',
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enlace copiado')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(c.descripcion, style: const TextStyle(fontSize: 14, height: 1.45)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: c.generos.map((g) => Chip(label: Text(g))).toList(),
                  ),
                  if (c.tipo == TipoContenido.serie) ...[
                    const SizedBox(height: 18),
                    const Text('Temporada 1', style: AppTheme.tituloSeccion),
                    const SizedBox(height: 8),
                    ...List.generate(
                      4,
                      (i) => _Episodio(
                        contenido: c,
                        numero: i + 1,
                        onTap: () => _reproducir(context, episodio: 'T1:E${i + 1}'),
                      ),
                    ),
                  ],
                  if (similares.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    const Text('Más como esto', style: AppTheme.tituloSeccion),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
          if (similares.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2 / 3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => PosterCard(
                    contenido: similares[i],
                    heroPrefijo: 'similar-${c.id}',
                  ),
                  childCount: similares.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  const _Accion({required this.icono, required this.texto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: Colors.white),
            const SizedBox(height: 4),
            Text(texto, style: const TextStyle(fontFamily: AppFonts.cuerpo, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _Episodio extends StatelessWidget {
  final Contenido contenido;
  final int numero;
  final VoidCallback onTap;
  const _Episodio({required this.contenido, required this.numero, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ImagenContenido(
                    ruta: contenido.imagenHorizontal,
                    width: 130,
                    height: 73,
                    textoRespaldo: 'E$numero',
                  ),
                  const Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$numero. Episodio $numero',
                    style: const TextStyle(
                      fontFamily: AppFonts.encabezado,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text('${40 + numero * 3} min', style: AppTheme.metadato),
                ],
              ),
            ),
            const Icon(Icons.download_outlined, color: AppColors.textoSecundario),
          ],
        ),
      ),
    );
  }
}
