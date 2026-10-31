import 'package:flutter/material.dart';

/// Perfil de usuario ("¿Quién está viendo?").
class Perfil {
  final String id;
  final String nombre;
  final Color color;
  final String? avatarAsset;
  final bool esNinos;

  const Perfil({
    required this.id,
    required this.nombre,
    required this.color,
    this.avatarAsset,
    this.esNinos = false,
  });
}

const List<Perfil> perfiles = [
  Perfil(
    id: 'pablo',
    nombre: 'Pablo',
    color: Color(0xFF00A8E1),
    avatarAsset: 'assets/images/avatar_perfil.png',
  ),
  Perfil(id: 'invitado', nombre: 'Invitado', color: Color(0xFF7B2CBF)),
  Perfil(id: 'ninos', nombre: 'Niños', color: Color(0xFFF77F00), esNinos: true),
];
