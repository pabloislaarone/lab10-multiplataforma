import 'package:flutter/material.dart';

import '../services/mi_lista_service.dart';
import '../theme/app_theme.dart';
import '../widgets/imagen_contenido.dart';
import '../widgets/tarjetas.dart';

class MiListaScreen extends StatelessWidget {
  const MiListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi lista',
          style: TextStyle(fontFamily: AppFonts.encabezado, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListenableBuilder(
        listenable: MiListaService.instancia,
        builder: (context, _) {
          final lista = MiListaService.instancia.contenidos;
          if (lista.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_add_outlined, size: 64, color: AppColors.textoSecundario),
                    SizedBox(height: 12),
                    Text('Tu lista está vacía', style: AppTheme.tituloSeccion),
                    SizedBox(height: 6),
                    Text(
                      'Toca + en cualquier título para guardarlo aquí. Se queda guardado aunque cierres la app.',
                      textAlign: TextAlign.center,
                      style: AppTheme.metadato,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = lista[i];
              return Dismissible(
                key: ValueKey(c.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) => MiListaService.instancia.alternar(c.id),
                child: InkWell(
                  onTap: () => abrirDetalle(context, c, heroPrefijo: 'milista'),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: 'milista-${c.id}',
                          child: ImagenContenido(
                            ruta: c.imagenHorizontal,
                            width: 150,
                            height: 84,
                            textoRespaldo: c.titulo,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.titulo,
                              style: const TextStyle(
                                fontFamily: AppFonts.encabezado,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text('${c.tipoTexto} · ${c.anio} · ${c.duracion}',
                                style: AppTheme.metadato),
                            const SizedBox(height: 4),
                            InsigniaPrime(incluido: c.incluidoConPrime),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
