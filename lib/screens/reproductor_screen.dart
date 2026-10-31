import 'dart:async';

import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/app_theme.dart';
import '../widgets/imagen_contenido.dart';

/// Reproductor simulado (sin video real) para mostrar el flujo de la app.
class ReproductorScreen extends StatefulWidget {
  final Contenido contenido;
  final String? episodio;
  const ReproductorScreen({super.key, required this.contenido, this.episodio});

  @override
  State<ReproductorScreen> createState() => _ReproductorScreenState();
}

class _ReproductorScreenState extends State<ReproductorScreen> {
  late double _posicion = widget.contenido.progreso;
  bool _reproduciendo = true;
  bool _controlesVisibles = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_reproduciendo && _posicion < 1) {
        setState(() => _posicion = (_posicion + 0.002).clamp(0.0, 1.0));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _tiempo(double fraccion) {
    final total = 100 * 60; // 100 min simulados
    final s = (total * fraccion).round();
    final m = s ~/ 60;
    return '${m ~/ 60}:${(m % 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }

  void _saltar(double segundos) {
    setState(() => _posicion = (_posicion + segundos / 6000).clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.contenido;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _controlesVisibles = !_controlesVisibles),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ImagenContenido(ruta: c.imagenHorizontal, wiki: c.wiki, alignment: Alignment.topCenter, textoRespaldo: c.titulo),
              ),
            ),
            AnimatedOpacity(
              opacity: _controlesVisibles ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: IgnorePointer(
                ignoring: !_controlesVisibles,
                child: Container(
                  color: Colors.black54,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.titulo,
                                    style: const TextStyle(
                                      fontFamily: AppFonts.encabezado,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (widget.episodio != null)
                                    Text(widget.episodio!, style: AppTheme.metadato),
                                ],
                              ),
                            ),
                            const Icon(Icons.subtitles_outlined, color: Colors.white),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              icon: const Icon(Icons.replay_10, color: Colors.white),
                              onPressed: () => _saltar(-10),
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              iconSize: 64,
                              icon: Icon(
                                _reproduciendo ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                color: Colors.white,
                              ),
                              onPressed: () => setState(() => _reproduciendo = !_reproduciendo),
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              iconSize: 40,
                              icon: const Icon(Icons.forward_10, color: Colors.white),
                              onPressed: () => _saltar(10),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(_tiempo(_posicion), style: AppTheme.metadato),
                              Expanded(
                                child: Slider(
                                  value: _posicion,
                                  activeColor: AppColors.azulPrime,
                                  inactiveColor: Colors.white24,
                                  onChanged: (v) => setState(() => _posicion = v),
                                ),
                              ),
                              Text(_tiempo(1), style: AppTheme.metadato),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
