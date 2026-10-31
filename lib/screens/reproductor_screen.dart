import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../data/catalogo.dart';
import '../models/contenido.dart';
import '../services/estado_usuario.dart';
import '../theme/app_theme.dart';

/// Abre el reproductor retomando donde se quedó el usuario.
void abrirReproductor(BuildContext context, Contenido c, {bool trailer = false, int? episodio}) {
  HapticFeedback.lightImpact();
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => ReproductorScreen(contenido: c, trailer: trailer, episodio: episodio),
  ));
}

/// Reproductor de video real (video de muestra público) con:
/// - pantalla completa horizontal
/// - doble toque a los lados para retroceder/adelantar 10 s
/// - controles que se ocultan solos, velocidad, silencio
/// - guarda el progreso para "Continuar viendo"
/// - botón "Siguiente episodio" al final de cada capítulo
class ReproductorScreen extends StatefulWidget {
  final Contenido contenido;
  final bool trailer;
  final int? episodio;
  const ReproductorScreen({
    super.key,
    required this.contenido,
    this.trailer = false,
    this.episodio,
  });

  @override
  State<ReproductorScreen> createState() => _ReproductorScreenState();
}

class _ReproductorScreenState extends State<ReproductorScreen> {
  late VideoPlayerController _video;
  late int _episodio;
  bool _listo = false;
  bool _error = false;
  bool _controles = true;
  bool _silencio = false;
  double _velocidad = 1;
  Timer? _ocultar;
  Timer? _guardado;
  String? _saltoTexto; // "-10 s" / "+10 s"
  bool _saltoIzquierda = false;

  Contenido get c => widget.contenido;
  bool get _esSerie => c.tipo == TipoContenido.serie && !widget.trailer;

  @override
  void initState() {
    super.initState();
    _episodio = widget.episodio ?? EstadoUsuario.instancia.episodioDe(c.id);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _iniciarVideo(retomar: widget.episodio == null);
  }

  Future<void> _iniciarVideo({required bool retomar}) async {
    setState(() {
      _listo = false;
      _error = false;
    });
    _video = VideoPlayerController.networkUrl(
      Uri.parse(widget.trailer ? videoTrailer : videoContenido),
    );
    try {
      await _video.initialize();
      if (!mounted) return;
      final previo = EstadoUsuario.instancia.progresoDe(c.id);
      if (retomar && !widget.trailer && previo > 0 && previo < 0.97) {
        await _video.seekTo(_video.value.duration * previo);
      }
      await _video.setVolume(_silencio ? 0 : 1);
      await _video.setPlaybackSpeed(_velocidad);
      await _video.play();
      _video.addListener(_alCambiar);
      _guardado = Timer.periodic(const Duration(seconds: 5), (_) => _guardarProgreso());
      setState(() => _listo = true);
      _programarOcultar();
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  void _alCambiar() {
    if (mounted) setState(() {});
  }

  double get _fraccion {
    final total = _video.value.duration.inMilliseconds;
    if (total == 0) return 0;
    return _video.value.position.inMilliseconds / total;
  }

  void _guardarProgreso() {
    if (!_listo || widget.trailer) return;
    EstadoUsuario.instancia.guardarProgreso(
      c.id,
      _fraccion,
      episodio: _esSerie ? _episodio : null,
    );
  }

  void _programarOcultar() {
    _ocultar?.cancel();
    _ocultar = Timer(const Duration(seconds: 3), () {
      if (mounted && _video.value.isPlaying) setState(() => _controles = false);
    });
  }

  void _mostrarControles() {
    setState(() => _controles = !_controles);
    if (_controles) _programarOcultar();
  }

  void _playPausa() {
    HapticFeedback.selectionClick();
    _video.value.isPlaying ? _video.pause() : _video.play();
    _programarOcultar();
  }

  Future<void> _saltar(int segundos) async {
    HapticFeedback.lightImpact();
    final nueva = _video.value.position + Duration(seconds: segundos);
    await _video.seekTo(nueva < Duration.zero ? Duration.zero : nueva);
    setState(() {
      _saltoTexto = segundos < 0 ? '−10 s' : '+10 s';
      _saltoIzquierda = segundos < 0;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _saltoTexto = null);
    });
  }

  Future<void> _siguienteEpisodio() async {
    _guardarProgreso();
    _video.removeListener(_alCambiar);
    _guardado?.cancel();
    setState(() {
      _listo = false; // evita usar el controlador mientras se cambia
      _episodio++;
    });
    await _video.dispose();
    EstadoUsuario.instancia.guardarProgreso(c.id, 0.001, episodio: _episodio);
    await _iniciarVideo(retomar: false);
  }

  void _elegirVelocidad() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.superficie,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0.5, 1.0, 1.25, 1.5, 2.0]
              .map((v) => ListTile(
                    title: Text('${v}x', style: const TextStyle(fontFamily: AppFonts.cuerpo)),
                    trailing: v == _velocidad
                        ? const Icon(Icons.check, color: AppColors.azulPrime)
                        : null,
                    onTap: () {
                      setState(() => _velocidad = v);
                      _video.setPlaybackSpeed(v);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _guardarProgreso();
    _ocultar?.cancel();
    _guardado?.cancel();
    _video.removeListener(_alCambiar);
    _video.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formato(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final subtitulo = widget.trailer
        ? 'Tráiler'
        : _esSerie
            ? 'Temporada 1 · Episodio $_episodio'
            : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------- Video ----------
          Center(
            child: _error
                ? _Error(onReintentar: () => _iniciarVideo(retomar: true))
                : !_listo
                    ? const CircularProgressIndicator(color: AppColors.azulPrime)
                    : AspectRatio(
                        aspectRatio: _video.value.aspectRatio,
                        child: VideoPlayer(_video),
                      ),
          ),
          if (_listo && _video.value.isBuffering)
            const Center(child: CircularProgressIndicator(color: Colors.white70)),

          // ---------- Zonas de gesto (doble toque) ----------
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _mostrarControles,
                  onDoubleTap: _listo ? () => _saltar(-10) : null,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _mostrarControles,
                  onDoubleTap: _listo ? () => _saltar(10) : null,
                ),
              ),
            ],
          ),
          if (_saltoTexto != null)
            Align(
              alignment: _saltoIzquierda ? const Alignment(-0.6, 0) : const Alignment(0.6, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _saltoTexto!,
                  style: const TextStyle(
                    fontFamily: AppFonts.encabezado,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

          // ---------- Controles ----------
          IgnorePointer(
            ignoring: !_controles,
            child: AnimatedOpacity(
              opacity: _controles ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: _controlesUI(subtitulo),
            ),
          ),

          // ---------- Siguiente episodio ----------
          if (_listo && _esSerie && _fraccion > 0.9)
            Positioned(
              right: 24,
              bottom: 90,
              child: FilledButton.icon(
                onPressed: _siguienteEpisodio,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.skip_next),
                label: Text(
                  'Episodio ${_episodio + 1}',
                  style: const TextStyle(
                    fontFamily: AppFonts.encabezado,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _controlesUI(String? subtitulo) {
    final pos = _listo ? _video.value.position : Duration.zero;
    final total = _listo ? _video.value.duration : Duration.zero;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.transparent, Colors.transparent, Colors.black87],
          stops: [0, 0.3, 0.7, 1],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Barra superior
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppFonts.encabezado,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (subtitulo != null) Text(subtitulo, style: AppTheme.metadato),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Velocidad',
                  icon: const Icon(Icons.speed, color: Colors.white),
                  onPressed: _elegirVelocidad,
                ),
                IconButton(
                  tooltip: 'Silenciar',
                  icon: Icon(_silencio ? Icons.volume_off : Icons.volume_up, color: Colors.white),
                  onPressed: () {
                    setState(() => _silencio = !_silencio);
                    _video.setVolume(_silencio ? 0 : 1);
                  },
                ),
                IconButton(
                  tooltip: 'Subtítulos',
                  icon: const Icon(Icons.subtitles_outlined, color: Colors.white),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subtítulos: Español (Latinoamérica)')),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Centro
            if (_listo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    icon: const Icon(Icons.replay_10, color: Colors.white),
                    onPressed: () => _saltar(-10),
                  ),
                  const SizedBox(width: 36),
                  IconButton(
                    iconSize: 68,
                    icon: Icon(
                      _video.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    onPressed: _playPausa,
                  ),
                  const SizedBox(width: 36),
                  IconButton(
                    iconSize: 42,
                    icon: const Icon(Icons.forward_10, color: Colors.white),
                    onPressed: () => _saltar(10),
                  ),
                ],
              ),
            const Spacer(),
            // Barra de progreso
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Text(_formato(pos), style: AppTheme.metadato.copyWith(color: Colors.white)),
                  Expanded(
                    child: _listo
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: VideoProgressIndicator(
                              _video,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              colors: const VideoProgressColors(
                                playedColor: AppColors.azulPrime,
                                bufferedColor: Colors.white38,
                                backgroundColor: Colors.white12,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Text(
                    '-${_formato(total - pos)}',
                    style: AppTheme.metadato.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  final VoidCallback onReintentar;
  const _Error({required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_off, size: 48, color: Colors.white54),
        const SizedBox(height: 10),
        const Text('No se pudo cargar el video', style: AppTheme.tituloSeccion),
        const SizedBox(height: 10),
        OutlinedButton(onPressed: onReintentar, child: const Text('Reintentar')),
      ],
    );
  }
}
