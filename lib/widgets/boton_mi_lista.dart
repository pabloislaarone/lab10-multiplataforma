import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../services/mi_lista_service.dart';
import '../theme/app_theme.dart';

/// Botón circular "+" / "✓" para agregar o quitar de Mi lista.
class BotonMiLista extends StatelessWidget {
  final Contenido contenido;
  final bool conTexto;
  const BotonMiLista({super.key, required this.contenido, this.conTexto = false});

  Future<void> _alternar(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final agregado = await MiListaService.instancia.alternar(contenido.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(agregado
            ? '"${contenido.titulo}" se agregó a Mi lista'
            : '"${contenido.titulo}" se quitó de Mi lista'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MiListaService.instancia,
      builder: (context, _) {
        final enLista = MiListaService.instancia.contiene(contenido.id);
        final icono = AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
          child: Icon(
            enLista ? Icons.check : Icons.add,
            key: ValueKey(enLista),
            color: Colors.white,
          ),
        );

        if (conTexto) {
          return InkWell(
            onTap: () => _alternar(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icono,
                  const SizedBox(height: 4),
                  Text(
                    enLista ? 'En mi lista' : 'Mi lista',
                    style: const TextStyle(fontFamily: AppFonts.cuerpo, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }

        return Material(
          color: Colors.white.withAlpha(40),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _alternar(context),
            child: Padding(padding: const EdgeInsets.all(10), child: icono),
          ),
        );
      },
    );
  }
}
