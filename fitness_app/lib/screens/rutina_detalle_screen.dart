import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rutinas_provider.dart';
import '../providers/sesiones_provider.dart';
import '../providers/deportes_provider.dart';
import '../providers/auth_provider.dart';
import '../models/rutina.dart';

class RutinaDetalleScreen extends StatefulWidget {
  const RutinaDetalleScreen({super.key});

  @override
  State<RutinaDetalleScreen> createState() => _RutinaDetalleScreenState();
}

class _RutinaDetalleScreenState extends State<RutinaDetalleScreen> {
  late Rutina _rutina;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rutina = ModalRoute.of(context)!.settings.arguments as Rutina;
  }

  @override
  Widget build(BuildContext context) {
    final rutinas = context.watch<RutinasProvider>();
    final sesiones = context.read<SesionesProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_rutina.nombre, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFC6F135)),
            onPressed: () async {
              final actualizada = await showDialog<Rutina>(
                context: context,
                builder: (ctx) => _EditarRutinaDialog(rutina: _rutina),
              );
              if (actualizada != null && mounted) {
                setState(() => _rutina = actualizada);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFFF4444)),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1A1A),
                  title: const Text('Eliminar rutina', style: TextStyle(color: Colors.white)),
                  content: const Text('¿Estás seguro?', style: TextStyle(color: Color(0xFF888888))),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4444),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await rutinas.deleteRutina(_rutina.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _rutina.nombre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              _rutina.descripcion ?? 'Sin descripción',
              style: const TextStyle(color: Color(0xFF888888)),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (ctx) => const _NuevaSesionDialog(),
                );
                if (result != null && context.mounted) {
                  await sesiones.createSesion(
                    _rutina.id,
                    auth.usuario!.id,
                    result['duracion'],
                    result['notas'],
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesión registrada'),
                        backgroundColor: Color(0xFFC6F135),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar sesión de entrenamiento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC6F135),
                foregroundColor: const Color(0xFF0D0D0D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                final deporte = context
                    .read<DeportesProvider>()
                    .deportes
                    .where((d) => d.id == _rutina.deporteId)
                    .firstOrNull;
                Navigator.pushNamed(context, '/sesiones', arguments: deporte);
              },
              icon: const Icon(Icons.history, color: Color(0xFFC6F135)),
              label: const Text('Ver historial de sesiones', style: TextStyle(color: Color(0xFFC6F135))),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFC6F135)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditarRutinaDialog extends StatefulWidget {
  final Rutina rutina;
  const _EditarRutinaDialog({required this.rutina});

  @override
  State<_EditarRutinaDialog> createState() => _EditarRutinaDialogState();
}

class _EditarRutinaDialogState extends State<_EditarRutinaDialog> {
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.rutina.nombre);
    _descripcionController = TextEditingController(text: widget.rutina.descripcion ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: const Text('Editar rutina', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nombreController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Nombre',
              labelStyle: const TextStyle(color: Color(0xFF888888)),
              filled: true,
              fillColor: const Color(0xFF242424),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descripcionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Descripción (opcional)',
              labelStyle: const TextStyle(color: Color(0xFF888888)),
              filled: true,
              fillColor: const Color(0xFF242424),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(0xFF888888))),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _guardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6F135),
            foregroundColor: const Color(0xFF0D0D0D),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0D0D0D)),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _guardar() async {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) return;
    setState(() => _isLoading = true);
    final actualizada = await context.read<RutinasProvider>().updateRutina(
      widget.rutina.id,
      {
        'nombre': nombre,
        'descripcion': _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        'deporte_id': widget.rutina.deporteId,
      },
    );
    if (mounted) Navigator.pop(context, actualizada);
  }
}

class _NuevaSesionDialog extends StatefulWidget {
  const _NuevaSesionDialog();

  @override
  State<_NuevaSesionDialog> createState() => _NuevaSesionDialogState();
}

class _NuevaSesionDialogState extends State<_NuevaSesionDialog> {
  final _duracionController = TextEditingController();
  final _notasController = TextEditingController();

  @override
  void dispose() {
    _duracionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: const Text('Nueva sesión', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _duracionController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Duración (minutos)',
              labelStyle: const TextStyle(color: Color(0xFF888888)),
              filled: true,
              fillColor: const Color(0xFF242424),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notasController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notas (opcional)',
              labelStyle: const TextStyle(color: Color(0xFF888888)),
              filled: true,
              fillColor: const Color(0xFF242424),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Color(0xFF888888))),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'duracion': int.tryParse(_duracionController.text),
            'notas': _notasController.text.trim().isEmpty
                ? null
                : _notasController.text.trim(),
          }),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6F135),
            foregroundColor: const Color(0xFF0D0D0D),
          ),
          child: const Text('Iniciar'),
        ),
      ],
    );
  }
}
