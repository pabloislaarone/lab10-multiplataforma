import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Esqueleto con brillo animado (efecto "shimmer") mientras carga una imagen,
/// como en las apps de streaming. Hecho solo con Flutter, sin paquetes.
class Shimmer extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  const Shimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final x = -1.5 + _c.value * 3;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(x - 1, -0.3),
              end: Alignment(x + 1, 0.3),
              colors: const [
                AppColors.superficie,
                AppColors.superficieAlta,
                Color(0xFF2E3B4B),
                AppColors.superficieAlta,
                AppColors.superficie,
              ],
              stops: const [0, 0.35, 0.5, 0.65, 1],
            ),
          ),
        );
      },
    );
  }
}
