import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rutinas_provider.dart';
import '../models/deporte.dart';

class RutinasScreen extends StatefulWidget {
  const RutinasScreen({super.key});

  @override
  State<RutinasScreen> createState() => _RutinasScreenState();
}

class _RutinasScreenState extends State<RutinasScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<RutinasProvider>().fetchRutinas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deporte = ModalRoute.of(context)!.settings.arguments as Deporte;
    final rutinas = context.watch<RutinasProvider>();
    final lista = rutinas.getRutinasByDeporte(deporte.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(deporte.nombre, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFFC6F135)),
            onPressed: () => Navigator.pushNamed(context, '/sesiones', arguments: deporte),
          ),
        ],
      ),
      body: rutinas.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFC6F135)))
          : lista.isEmpty
              ? const Center(child: Text('No hay rutinas aún', style: TextStyle(color: Color(0xFF888888))))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lista.length,
                  itemBuilder: (ctx, i) {
                    final rutina = lista[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.fitness_center, color: Color(0xFFC6F135)),
                        title: Text(rutina.nombre, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(rutina.descripcion ?? '', style: const TextStyle(color: Color(0xFF888888))),
                        trailing: const Icon(Icons.chevron_right, color: Color(0xFF888888)),
                        onTap: () => Navigator.pushNamed(context, '/rutina-detalle', arguments: rutina),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC6F135),
        foregroundColor: const Color(0xFF0D0D0D),
        onPressed: () => Navigator.pushNamed(context, '/rutina-create', arguments: deporte),
        child: const Icon(Icons.add),
      ),
    );
  }
}
