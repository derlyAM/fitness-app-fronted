import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rutinas_provider.dart';
import '../models/deporte.dart';

class RutinaCreateScreen extends StatefulWidget {
  const RutinaCreateScreen({super.key});

  @override
  State<RutinaCreateScreen> createState() => _RutinaCreateScreenState();
}

class _RutinaCreateScreenState extends State<RutinaCreateScreen> {
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    final deporte = ModalRoute.of(context)!.settings.arguments as Deporte;
    final rutinas = context.read<RutinasProvider>();
    final success = await rutinas.createRutina(
      _nombreController.text.trim(),
      _descripcionController.text.trim(),
      deporte.id,
    );
    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final rutinas = context.watch<RutinasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva rutina', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: const TextStyle(color: Color(0xFF888888)),
                filled: true,
                fillColor: const Color(0xFF242424),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descripcionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: const TextStyle(color: Color(0xFF888888)),
                filled: true,
                fillColor: const Color(0xFF242424),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: rutinas.isLoading ? null : _crear,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC6F135),
                foregroundColor: const Color(0xFF0D0D0D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: rutinas.isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF0D0D0D))
                  : const Text('Crear rutina', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
