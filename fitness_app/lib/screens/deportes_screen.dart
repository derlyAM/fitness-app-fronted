import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deportes_provider.dart';
import '../providers/sesiones_provider.dart';
import '../providers/auth_provider.dart';

class DeportesScreen extends StatefulWidget {
  const DeportesScreen({super.key});

  @override
  State<DeportesScreen> createState() => _DeportesScreenState();
}

class _DeportesScreenState extends State<DeportesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DeportesProvider>().fetchDeportes();
        context.read<SesionesProvider>().fetchSesiones();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deportes = context.watch<DeportesProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deportes', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF888888)),
            onPressed: () async {
              final nav = Navigator.of(context);
              await auth.logout();
              if (mounted) nav.pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: deportes.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFC6F135)))
          : deportes.error != null
              ? Center(child: Text(deportes.error!, style: const TextStyle(color: Color(0xFFFF4444))))
              : Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        itemCount: deportes.deportes.length,
                        itemBuilder: (ctx, i) {
                          final deporte = deportes.deportes[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.sports, color: Color(0xFFC6F135)),
                              title: Text(deporte.nombre, style: const TextStyle(color: Colors.white)),
                              trailing: const Icon(Icons.chevron_right, color: Color(0xFF888888)),
                              onTap: () => Navigator.pushNamed(context, '/rutinas', arguments: deporte),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: const Row(
                        children: [
                          Icon(Icons.history, color: Color(0xFFC6F135), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Historial completo',
                            style: TextStyle(
                              color: Color(0xFFC6F135),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<SesionesProvider>(
                        builder: (ctx, sesiones, _) {
                          if (sesiones.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: Color(0xFFC6F135)),
                            );
                          }
                          if (sesiones.sesiones.isEmpty) {
                            return const Center(
                              child: Text(
                                'Sin sesiones registradas',
                                style: TextStyle(color: Color(0xFF888888)),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: sesiones.sesiones.length,
                            itemBuilder: (ctx, i) {
                              final sesion = sesiones.sesiones[i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFFC6F135),
                                    size: 18,
                                  ),
                                  title: Text(
                                    sesion.nombreDeporte ?? 'Sin deporte',
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '${sesion.fecha.day}/${sesion.fecha.month}/${sesion.fecha.year} — ${sesion.duracion != null ? '${sesion.duracion} min' : 'Sin duración'}',
                                    style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/sesion-detalle',
                                    arguments: sesion,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC6F135),
        foregroundColor: const Color(0xFF0D0D0D),
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Nuevo deporte', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Nombre',
            labelStyle: TextStyle(color: Color(0xFF888888)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF888888))),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<DeportesProvider>().createDeporte(controller.text.trim(), null);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC6F135),
              foregroundColor: const Color(0xFF0D0D0D),
            ),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}
