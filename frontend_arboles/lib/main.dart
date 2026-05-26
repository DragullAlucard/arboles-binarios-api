import 'package:flutter/material.dart';

import 'screens/construir_screen.dart';
import 'screens/recorridos_screen.dart';
import 'screens/reconstruir_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const ArbolesApp());
}

class ArbolesApp extends StatefulWidget {
  const ArbolesApp({super.key});

  @override
  State<ArbolesApp> createState() => _ArbolesAppState();
}

class _ArbolesAppState extends State<ArbolesApp> {
  bool modoOscuro = false;

  void cambiarTema() {
    setState(() {
      modoOscuro = !modoOscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Árboles Binarios',
      themeMode: modoOscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: HomeScreen(
        modoOscuro: modoOscuro,
        cambiarTema: cambiarTema,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool modoOscuro;
  final VoidCallback cambiarTema;

  const HomeScreen({
    super.key,
    required this.modoOscuro,
    required this.cambiarTema,
  });

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final esMovil = ancho < 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyecto Árboles Binarios'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: cambiarTema,
            icon: Icon(
              modoOscuro ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Cambiar tema',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.account_tree,
                  size: esMovil ? 70 : 90,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 15),
                Text(
                  'Sistema de Árbol Binario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 28 : 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Construcción, recorridos y reconstrucción de árboles binarios',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 15 : 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 35),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _OpcionCard(
                      icono: Icons.account_tree,
                      titulo: 'Construir Árbol',
                      descripcion:
                          'Crear nodos e insertar hijos izquierdos o derechos.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConstruirScreen(),
                          ),
                        );
                      },
                    ),
                    _OpcionCard(
                      icono: Icons.route,
                      titulo: 'Recorridos',
                      descripcion: 'Visualizar preorden, inorden y postorden.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecorridosScreen(),
                          ),
                        );
                      },
                    ),
                    _OpcionCard(
                      icono: Icons.restart_alt,
                      titulo: 'Reconstrucción',
                      descripcion:
                          'Reconstruir el árbol usando preorden e inorden.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReconstruirScreen(),
                          ),
                        );
                      },
                    ),
                    _OpcionCard(
                      icono: Icons.info_outline,
                      titulo: 'Acerca de',
                      descripcion:
                          'Información del proyecto, tecnologías y créditos.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Programación III · 2026',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OpcionCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  const _OpcionCard({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final esMovil = ancho < 700;

    return SizedBox(
      width: esMovil ? double.infinity : 300,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  icono,
                  size: 55,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 18),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  descripcion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Abrir'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}