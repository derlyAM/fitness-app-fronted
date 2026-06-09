import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sesiones_provider.dart';
import '../models/sesion.dart';

class SesionDetalleScreen extends StatefulWidget {
  const SesionDetalleScreen({super.key});

  @override
  State<SesionDetalleScreen> createState() => _SesionDetalleScreenState();
}

class _SesionDetalleScreenState extends State<SesionDetalleScreen> {
  late Sesion _sesion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sesion = ModalRoute.of(context)!.settings.arguments as Sesion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de sesión', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFC6F135)),
            onPressed: () async {
              final actualizada = await showDialog<Sesion>(
                context: context,
                builder: (ctx) => _EditarSesionDialog(sesion: _sesion),
              );
              if (actualizada != null && mounted) {
                setState(() => _sesion = actualizada);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _infoCard('Fecha', '${_sesion.fecha.day}/${_sesion.fecha.month}/${_sesion.fecha.year}', Icons.calendar_today),
            _infoCard('Hora', '${_sesion.fecha.hour}:${_sesion.fecha.minute.toString().padLeft(2, '0')}', Icons.access_time),
            _infoCard('Duración', _sesion.duracion != null ? '${_sesion.duracion} min' : 'No registrada', Icons.timer),
            _infoCard('Notas', _sesion.notas ?? 'Sin notas', Icons.notes),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC6F135), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF888888), fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditarSesionDialog extends StatefulWidget {
  final Sesion sesion;
  const _EditarSesionDialog({required this.sesion});

  @override
  State<_EditarSesionDialog> createState() => _EditarSesionDialogState();
}

class _EditarSesionDialogState extends State<_EditarSesionDialog> {
  late final TextEditingController _duracionController;
  late final TextEditingController _notasController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _duracionController = TextEditingController(
      text: widget.sesion.duracion?.toString() ?? '',
    );
    _notasController = TextEditingController(
      text: widget.sesion.notas ?? '',
    );
  }

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
      title: const Text('Editar sesión', style: TextStyle(color: Colors.white)),
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
    setState(() => _isLoading = true);
    final actualizada = await context.read<SesionesProvider>().updateSesion(
      widget.sesion.id,
      {
        'rutina_id': widget.sesion.rutinaId,
        'duracion': int.tryParse(_duracionController.text),
        'notas': _notasController.text.trim().isEmpty
            ? null
            : _notasController.text.trim(),
      },
    );
    if (mounted) Navigator.pop(context, actualizada);
  }
}
