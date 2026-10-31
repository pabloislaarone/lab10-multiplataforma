import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/perfil.dart';
import '../services/estado_usuario.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_perfil.dart';
import '../widgets/logo_prime.dart';
import 'main_shell.dart';

/// "¿Quién está viendo?" — cada perfil tiene su propia Mi lista,
/// progreso, me gusta, descargas e historial.
class PerfilesScreen extends StatefulWidget {
  final bool cambiando;
  const PerfilesScreen({super.key, this.cambiando = false});

  @override
  State<PerfilesScreen> createState() => _PerfilesScreenState();
}

class _PerfilesScreenState extends State<PerfilesScreen> {
  String? _cargando;

  Future<void> _elegir(Perfil p) async {
    HapticFeedback.mediumImpact();
    setState(() => _cargando = p.id);
    await Future.wait([
      EstadoUsuario.instancia.seleccionarPerfil(p),
      Future.delayed(const Duration(milliseconds: 600)),
    ]);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(
          opacity: a,
          child: ScaleTransition(
            scale: Tween(begin: 1.05, end: 1.0).animate(a),
            child: child,
          ),
        ),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.cambiando,
        title: const LogoPrime(),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                '¿Quién está viendo?',
                style: TextStyle(
                  fontFamily: AppFonts.encabezado,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 26,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: perfiles.map(_tarjeta).toList(),
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Puedes tener hasta 6 perfiles por cuenta')),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                ),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Administrar perfiles'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjeta(Perfil p) {
    final actual = widget.cambiando && EstadoUsuario.instancia.perfil.id == p.id;
    return GestureDetector(
      onTap: _cargando == null ? () => _elegir(p) : null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _cargando == p.id ? 1.12 : 1,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: actual || _cargando == p.id ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AvatarPerfil(perfil: p, radio: 44),
                  if (_cargando == p.id)
                    const SizedBox(
                      width: 92,
                      height: 92,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              p.nombre,
              style: const TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w600),
            ),
            if (p.esNinos) const Text('Contenido infantil', style: AppTheme.metadato),
          ],
        ),
      ),
    );
  }
}
