import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sesiones_provider.dart';
import '../providers/rutinas_provider.dart';
import '../models/deporte.dart';
import '../models/sesion.dart';

class SesionesScreen extends StatefulWidget {
  const SesionesScreen({super.key});

  @override
  State<SesionesScreen> createState() => _SesionesScreenState();
}

class _SesionesScreenState extends State<SesionesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<SesionesProvider>().fetchSesiones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deporte = ModalRoute.of(context)!.settings.arguments as Deporte?;
    final sesiones = context.watch<SesionesProvider>();

    final List<Sesion> lista;
    if (deporte != null) {
      final rutinaIds = context
          .read<RutinasProvider>()
          .getRutinasByDeporte(deporte.id)
          .map((r) => r.id)
          .toSet();
      lista = sesiones.sesiones.where((s) => rutinaIds.contains(s.rutinaId)).toList();
    } else {
      lista = sesiones.sesiones;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          deporte != null ? 'Historial — ${deporte.nombre}' : 'Historial',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: sesiones.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFC6F135)))
          : lista.isEmpty
              ? const Center(
                  child: Text('No hay sesiones registradas', style: TextStyle(color: Color(0xFF888888))),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lista.length,
                  itemBuilder: (ctx, i) {
                    final sesion = lista[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today, color: Color(0xFFC6F135)),
                        title: Text(
                          '${sesion.fecha.day}/${sesion.fecha.month}/${sesion.fecha.year}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${sesion.fecha.hour}:${sesion.fecha.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Color(0xFF888888)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Color(0xFFFF4444)),
                          onPressed: () => sesiones.deleteSesion(sesion.id),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/sesion-detalle', arguments: sesion),
                      ),
                    );
                  },
                ),
    );
  }
}
