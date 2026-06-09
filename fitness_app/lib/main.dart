import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/deportes_provider.dart';
import 'providers/rutinas_provider.dart';
import 'providers/sesiones_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/deportes_screen.dart';
import 'screens/rutinas_screen.dart';
import 'screens/rutina_detalle_screen.dart';
import 'screens/rutina_create_screen.dart';
import 'screens/sesiones_screen.dart';
import 'screens/sesion_detalle_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DeportesProvider>(
          create: (ctx) => DeportesProvider(ctx.read<AuthProvider>().api),
          update: (ctx, auth, previous) => DeportesProvider(auth.api),
        ),
        ChangeNotifierProxyProvider<AuthProvider, RutinasProvider>(
          create: (ctx) => RutinasProvider(ctx.read<AuthProvider>().api),
          update: (ctx, auth, previous) => RutinasProvider(auth.api),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SesionesProvider>(
          create: (ctx) => SesionesProvider(ctx.read<AuthProvider>().api),
          update: (ctx, auth, previous) => SesionesProvider(auth.api),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC6F135),
          surface: Color(0xFF1A1A1A),
          onPrimary: Color(0xFF0D0D0D),
          onSurface: Color(0xFFFFFFFF),
          error: Color(0xFFFF4444),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const LoginScreen(),
        '/register': (ctx) => const RegisterScreen(),
        '/deportes': (ctx) => const DeportesScreen(),
        '/rutinas': (ctx) => const RutinasScreen(),
        '/rutina-detalle': (ctx) => const RutinaDetalleScreen(),
        '/rutina-create': (ctx) => const RutinaCreateScreen(),
        '/sesiones': (ctx) => const SesionesScreen(),
        '/sesion-detalle': (ctx) => const SesionDetalleScreen(),
      },
    );
  }
}
