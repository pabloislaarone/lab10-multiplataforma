import 'package:flutter/material.dart';

import '../models/perfil.dart';
import '../theme/app_theme.dart';

/// Avatar de un perfil: imagen local si tiene, si no la inicial con su color.
class AvatarPerfil extends StatelessWidget {
  final Perfil perfil;
  final double radio;
  const AvatarPerfil({super.key, required this.perfil, this.radio = 36});

  @override
  Widget build(BuildContext context) {
    if (perfil.avatarAsset != null) {
      return CircleAvatar(radius: radio, backgroundImage: AssetImage(perfil.avatarAsset!));
    }
    return CircleAvatar(
      radius: radio,
      backgroundColor: perfil.color,
      child: perfil.esNinos
          ? Icon(Icons.child_care, size: radio, color: Colors.white)
          : Text(
              perfil.nombre[0],
              style: TextStyle(
                fontFamily: AppFonts.encabezado,
                fontWeight: FontWeight.w800,
                fontSize: radio * 0.9,
                color: Colors.white,
              ),
            ),
    );
  }
}
