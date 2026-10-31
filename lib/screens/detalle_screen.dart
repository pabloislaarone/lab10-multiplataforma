import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../services/estado_usuario.dart';
import '../theme/app_theme.dart';
import '../widgets/boton_mi_lista.dart';
import '../widgets/imagen_contenido.dart';
import '../widgets/tarjetas.dart';
import 'reproductor_screen.dart';

enum _Pestana { episodios, relacionados, detalles }

class DetalleScreen extends StatefulWidget {
  final Contenido contenido;
  final String heroPrefijo;
  const DetalleScreen({super.key, required this.contenido, this.heroPrefijo = ''});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  late _Pestana _pestana =
      widget.contenido.tipo == TipoContenido.serie ? _Pestana.episodios : _Pestana.relacionados;
  bool _descripcionCompleta = false;

  Contenido get c => widget.contenido;
  bool get _esSerie => c.tipo == TipoContenido.serie;

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final estado = EstadoUsuario.instancia;

    return Scaffold(
      body: ListenableBuilder(
        listenable: estado,
        builder: (context, _) {
          final progreso = estado.progresoDe(c.id);
          final similares = similaresA(c);
          return CustomScrollView(
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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.cast, color: Colors.white),
                    onPressed: () => _aviso('Buscando dispositivos para transmitir…'),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: '${widget.heroPrefijo}-${c.id}',
                        child: ImagenContenido(
                          ruta: c.imagenHorizontal,
                          wiki: c.wiki,
                          alignment: Alignment.topCenter,
                          textoRespaldo: c.titulo,
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.fondo],
                            stops: [0.5, 1],
                          ),
                        ),
                      ),
                      Center(
                        child: IconButton(
                          iconSize: 64,
                          icon: const Icon(Icons.play_circle_fill, color: Colors.white70),
                          onPressed: () => abrirReproductor(context, c, trailer: true),
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
                        style: const TextStyle(fontFamily: AppFonts.titulo, fontSize: 42, height: 1),
                      ),
                      const SizedBox(height: 8),
                      _metadatos(),
                      const SizedBox(height: 8),
                      InsigniaPrime(incluido: c.incluidoConPrime),
                      const SizedBox(height: 16),

                      // Botón principal
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => abrirReproductor(context, c),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.azulPrime,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          icon: const Icon(Icons.play_arrow),
                          label: Text(
                            progreso > 0
                                ? (_esSerie
                                    ? 'Continuar T1:E${estado.episodioDe(c.id)}'
                                    : 'Continuar viendo')
                                : (_esSerie ? 'Reproducir T1:E1' : 'Reproducir'),
                            style: const TextStyle(
                              fontFamily: AppFonts.encabezado,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      if (progreso > 0) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progreso,
                            minHeight: 3,
                            backgroundColor: Colors.white12,
                            color: AppColors.azulPrime,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),

                      // Acciones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _Accion(
                            icono: Icons.movie_outlined,
                            texto: 'Tráiler',
                            onTap: () => abrirReproductor(context, c, trailer: true),
                          ),
                          BotonMiLista(contenido: c, conTexto: true),
                          _Accion(
                            icono: estado.valoracionDe(c.id) == 1
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            texto: 'Me gusta',
                            activo: estado.valoracionDe(c.id) == 1,
                            onTap: () => _valorar(1),
                          ),
                          _Accion(
                            icono: estado.valoracionDe(c.id) == -1
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined,
                            texto: 'No me gusta',
                            activo: estado.valoracionDe(c.id) == -1,
                            onTap: () => _valorar(-1),
                          ),
                          _BotonDescarga(contenido: c),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Descripción expandible
                      GestureDetector(
                        onTap: () => setState(() => _descripcionCompleta = !_descripcionCompleta),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.descripcion,
                                maxLines: _descripcionCompleta ? null : 2,
                                overflow: _descripcionCompleta ? null : TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, height: 1.45),
                              ),
                              Text(
                                _descripcionCompleta ? 'Ver menos' : 'Ver más',
                                style: const TextStyle(
                                  fontFamily: AppFonts.encabezado,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: AppColors.azulPrime,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Pestañas
                      Row(
                        children: [
                          if (_esSerie) _tab('Episodios', _Pestana.episodios),
                          _tab('Relacionados', _Pestana.relacionados),
                          _tab('Detalles', _Pestana.detalles),
                        ],
                      ),
                      const Divider(height: 1, color: Colors.white12),
                      const SizedBox(height: 10),
                      if (_pestana == _Pestana.episodios && _esSerie)
                        ...List.generate(
                          6,
                          (i) => _Episodio(
                            contenido: c,
                            numero: i + 1,
                            actual: estado.progresoDe(c.id) > 0 &&
                                estado.episodioDe(c.id) == i + 1,
                            onTap: () => abrirReproductor(context, c, episodio: i + 1),
                          ),
                        ),
                      if (_pestana == _Pestana.detalles) _detalles(),
                      if (_pestana == _Pestana.relacionados && similares.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No hay títulos relacionados', style: AppTheme.metadato),
                        ),
                    ],
                  ),
                ),
              ),
              if (_pestana == _Pestana.relacionados && similares.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }

  void _valorar(int valor) {
    HapticFeedback.selectionClick();
    final antes = EstadoUsuario.instancia.valoracionDe(c.id);
    EstadoUsuario.instancia.valorar(c.id, valor);
    if (antes != valor) {
      _aviso(valor == 1
          ? 'Gracias. Te recomendaremos más títulos como este.'
          : 'Entendido. Veremos menos títulos como este.');
    }
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto), duration: const Duration(seconds: 2)));
  }

  Widget _metadatos() => Wrap(
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
      );

  Widget _tab(String texto, _Pestana p) {
    final activo = _pestana == p;
    return GestureDetector(
      onTap: () => setState(() => _pestana = p),
      child: Container(
        margin: const EdgeInsets.only(right: 18),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: activo ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontFamily: AppFonts.encabezado,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: activo ? Colors.white : AppColors.textoSecundario,
          ),
        ),
      ),
    );
  }

  Widget _detalles() {
    Widget fila(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 110, child: Text(k, style: AppTheme.metadato)),
              Expanded(child: Text(v, style: const TextStyle(fontSize: 13))),
            ],
          ),
        );
    return Column(
      children: [
        fila('Tipo', c.tipoTexto),
        fila('Géneros', c.generos.join(', ')),
        fila('Año', '${c.anio}'),
        fila('Duración', c.duracion),
        fila('Clasificación', c.clasificacion),
        fila('IMDb', '${c.calificacion} (aprox.)'),
        fila('Disponibilidad', c.incluidoConPrime ? 'Incluido con Prime' : 'Alquiler o compra'),
      ],
    );
  }
}

class _Accion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final bool activo;
  const _Accion({
    required this.icono,
    required this.texto,
    required this.onTap,
    this.activo = false,
  });

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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
              child: Icon(
                icono,
                key: ValueKey(icono),
                color: activo ? AppColors.azulPrime : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(texto, style: const TextStyle(fontFamily: AppFonts.cuerpo, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

/// Botón de descarga con anillo de progreso (descarga simulada).
class _BotonDescarga extends StatelessWidget {
  final Contenido contenido;
  const _BotonDescarga({required this.contenido});

  @override
  Widget build(BuildContext context) {
    final estado = EstadoUsuario.instancia;
    final progreso = estado.descargaDe(contenido.id);
    final completa = progreso != null && progreso >= 1;

    Widget icono;
    if (progreso == null) {
      icono = const Icon(Icons.download_outlined, color: Colors.white);
    } else if (completa) {
      icono = const Icon(Icons.download_done, color: AppColors.azulPrime);
    } else {
      icono = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          value: progreso,
          strokeWidth: 2.5,
          color: AppColors.azulPrime,
          backgroundColor: Colors.white12,
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        HapticFeedback.selectionClick();
        if (progreso == null) {
          estado.iniciarDescarga(contenido.id);
        } else {
          estado.eliminarDescarga(contenido.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Descarga de "${contenido.titulo}" eliminada')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icono,
            const SizedBox(height: 4),
            Text(
              progreso == null
                  ? 'Descargar'
                  : completa
                      ? 'Descargado'
                      : '${(progreso * 100).round()}%',
              style: const TextStyle(fontFamily: AppFonts.cuerpo, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _Episodio extends StatelessWidget {
  final Contenido contenido;
  final int numero;
  final bool actual;
  final VoidCallback onTap;
  const _Episodio({
    required this.contenido,
    required this.numero,
    required this.actual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progreso = actual ? EstadoUsuario.instancia.progresoDe(contenido.id) : 0.0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 130,
                height: 73,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ImagenContenido(
                      ruta: contenido.imagenHorizontal,
                      wiki: contenido.wiki,
                      alignment: Alignment.topCenter,
                      textoRespaldo: 'E$numero',
                    ),
                    Container(color: Colors.black26),
                    const Center(
                      child: Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
                    ),
                    if (progreso > 0)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: LinearProgressIndicator(
                          value: progreso,
                          minHeight: 3,
                          backgroundColor: Colors.white24,
                          color: AppColors.azulPrime,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Episodio $numero',
                    style: TextStyle(
                      fontFamily: AppFonts.encabezado,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: actual ? AppColors.azulPrime : Colors.white,
                    ),
                  ),
                  Text(
                    actual ? 'Viendo ahora' : 'Temporada 1',
                    style: AppTheme.metadato,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textoSecundario),
          ],
        ),
      ),
    );
  }
}
