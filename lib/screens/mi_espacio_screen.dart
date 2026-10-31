import 'package:flutter/material.dart';

import '../services/mi_lista_service.dart';
import '../theme/app_theme.dart';

/// Perfil del usuario (avatar como imagen LOCAL).
class MiEspacioScreen extends StatelessWidget {
  const MiEspacioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi espacio',
          style: TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w800),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage('assets/images/avatar_perfil.png'),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pablo',
                      style: TextStyle(
                        fontFamily: AppFonts.encabezado,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    Text('Miembro Prime desde 2024', style: AppTheme.metadato),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: MiListaService.instancia,
            builder: (_, __) => Row(
              children: [
                _Dato(valor: '${MiListaService.instancia.contenidos.length}', etiqueta: 'En mi lista'),
                const SizedBox(width: 10),
                const _Dato(valor: '42 h', etiqueta: 'Vistas este mes'),
                const SizedBox(width: 10),
                const _Dato(valor: '3', etiqueta: 'Descargas'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _Opcion(icono: Icons.person_outline, texto: 'Perfiles'),
          const _Opcion(icono: Icons.download_outlined, texto: 'Descargas'),
          const _Opcion(icono: Icons.history, texto: 'Historial de reproducción'),
          const _Opcion(icono: Icons.language, texto: 'Idioma y subtítulos'),
          const _Opcion(icono: Icons.child_care, texto: 'Control parental'),
          const _Opcion(icono: Icons.help_outline, texto: 'Ayuda'),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String valor;
  final String etiqueta;
  const _Dato({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.superficieAlta,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: const TextStyle(
                fontFamily: AppFonts.titulo,
                fontSize: 32,
                color: AppColors.azulPrime,
              ),
            ),
            Text(etiqueta, style: AppTheme.metadato),
          ],
        ),
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final IconData icono;
  final String texto;
  const _Opcion({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icono, color: Colors.white),
      title: Text(texto, style: const TextStyle(fontFamily: AppFonts.cuerpo)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textoSecundario),
      onTap: () {},
    );
  }
}
