import 'package:flutter/material.dart';

import '../services/estado_usuario.dart';
import '../services/mi_lista_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar_perfil.dart';
import '../widgets/imagen_contenido.dart';
import '../widgets/seccion_horizontal.dart';
import '../widgets/tarjetas.dart';
import 'perfiles_screen.dart';
import 'reproductor_screen.dart';

/// Perfil: cambiar de perfil, estadísticas, vistos recientemente y descargas.
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
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Configuración disponible próximamente')),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([EstadoUsuario.instancia, MiListaService.instancia]),
        builder: (context, _) {
          final estado = EstadoUsuario.instancia;
          final vistos = estado.vistosRecientemente;
          final enCurso = estado.descargasEnCurso;
          final descargados = estado.descargados;

          return ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    AvatarPerfil(perfil: estado.perfil, radio: 34),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            estado.perfil.nombre,
                            style: const TextStyle(
                              fontFamily: AppFonts.encabezado,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            estado.esNinos ? 'Perfil infantil' : 'Perfil principal',
                            style: AppTheme.metadato,
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PerfilesScreen(cambiando: true)),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                      ),
                      child: const Text('Cambiar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _Dato(valor: '${MiListaService.instancia.contenidos.length}', etiqueta: 'En mi lista'),
                    const SizedBox(width: 10),
                    _Dato(valor: '${vistos.length}', etiqueta: 'Vistos'),
                    const SizedBox(width: 10),
                    _Dato(valor: '${descargados.length}', etiqueta: 'Descargas'),
                  ],
                ),
              ),
              if (vistos.isNotEmpty)
                SeccionHorizontal(
                  titulo: 'Vistos recientemente',
                  alto: 150,
                  cantidad: vistos.length,
                  itemBuilder: (_, i) =>
                      PosterCard(contenido: vistos[i], ancho: 100, heroPrefijo: 'visto'),
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text('Descargas', style: AppTheme.tituloSeccion),
              ),
              if (enCurso.isEmpty && descargados.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Toca "Descargar" en cualquier título para verlo sin conexión.',
                    style: AppTheme.metadato,
                  ),
                ),
              ...enCurso.map((e) => _FilaDescarga(
                    titulo: e.key.titulo,
                    ruta: e.key.imagen,
                    wiki: e.key.wiki,
                    progreso: e.value,
                    onEliminar: () => estado.eliminarDescarga(e.key.id),
                    onTap: () {},
                  )),
              ...descargados.map((c) => _FilaDescarga(
                    titulo: c.titulo,
                    ruta: c.imagen,
                    wiki: c.wiki,
                    progreso: 1,
                    onEliminar: () => estado.eliminarDescarga(c.id),
                    onTap: () => abrirReproductor(context, c),
                  )),
              const SizedBox(height: 16),
              const _Opcion(icono: Icons.history, texto: 'Historial de reproducción'),
              const _Opcion(icono: Icons.language, texto: 'Idioma y subtítulos'),
              const _Opcion(icono: Icons.child_care, texto: 'Control parental'),
              const _Opcion(icono: Icons.help_outline, texto: 'Ayuda'),
            ],
          );
        },
      ),
    );
  }
}

class _FilaDescarga extends StatelessWidget {
  final String titulo;
  final String ruta;
  final String wiki;
  final double progreso;
  final VoidCallback onEliminar;
  final VoidCallback onTap;

  const _FilaDescarga({
    required this.titulo,
    required this.ruta,
    required this.wiki,
    required this.progreso,
    required this.onEliminar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completa = progreso >= 1;
    return Dismissible(
      key: ValueKey('descarga-$titulo'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade700,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onEliminar(),
      child: ListTile(
        onTap: completa ? onTap : null,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ImagenContenido(ruta: ruta, wiki: wiki, width: 44, height: 66, textoRespaldo: ''),
        ),
        title: Text(titulo, style: const TextStyle(fontFamily: AppFonts.encabezado, fontSize: 14)),
        subtitle: completa
            ? const Text('Disponible sin conexión', style: AppTheme.metadato)
            : Padding(
                padding: const EdgeInsets.only(top: 6),
                child: LinearProgressIndicator(
                  value: progreso,
                  backgroundColor: Colors.white12,
                  color: AppColors.azulPrime,
                ),
              ),
        trailing: Icon(
          completa ? Icons.play_circle_outline : Icons.downloading,
          color: completa ? Colors.white : AppColors.azulPrime,
        ),
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
      leading: Icon(icono, color: Colors.white),
      title: Text(texto, style: const TextStyle(fontFamily: AppFonts.cuerpo)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textoSecundario),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$texto: próximamente')),
      ),
    );
  }
}
