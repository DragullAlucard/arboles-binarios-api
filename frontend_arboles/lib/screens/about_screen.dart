import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget infoCard({
    required BuildContext context,
    required IconData icono,
    required String titulo,
    required List<String> contenido,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icono,
              size: 35,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...contenido.map(
                    (texto) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        texto,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final esMovil = ancho < 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Icon(
                  Icons.account_tree,
                  size: esMovil ? 70 : 90,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 15),

                Text(
                  'Sistema de Árboles Binarios',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 28 : 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Aplicación académica para la construcción, recorridos y reconstrucción de árboles binarios.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 15 : 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 30),

                infoCard(
                  context: context,
                  icono: Icons.school,
                  titulo: 'Información académica',
                  contenido: const [
                    'Universidad Mariano Gálvez de Guatemala',
                    'Carrera: Ingeniería en Sistemas',
                    'Curso: Programación III',
                    'Año: 2026',
                  ],
                ),

                infoCard(
                  context: context,
                  icono: Icons.code,
                  titulo: 'Tecnologías utilizadas',
                  contenido: const [
                    'Flutter',
                    'Dart',
                    'Python',
                    'Flask',
                    'API REST',
                    'CustomPainter',
                    'InteractiveViewer',
                  ],
                ),

                infoCard(
                  context: context,
                  icono: Icons.extension,
                  titulo: 'Funcionalidades principales',
                  contenido: const [
                    'Construcción de árbol binario',
                    'Recorridos Preorden, Inorden y Postorden',
                    'Reconstrucción mediante Preorden e Inorden',
                    'Visualización gráfica del árbol',
                    'Modo claro y modo oscuro',
                    'Diseño responsive',
                  ],
                ),

                infoCard(
                  context: context,
                  icono: Icons.groups,
                  titulo: 'Créditos',
                  contenido: const [
                    'Desarrollado por:',
                    'Kevin Alexander López Dávila',
                    'Carné: 7690-20-11703',
                    'Integrantes adicionales pendientes de agregar',
                  ],
                ),

                infoCard(
                  context: context,
                  icono: Icons.info,
                  titulo: 'Versión',
                  contenido: const [
                    'Versión 1.0.0',
                    '© 2026',
                    'Proyecto desarrollado con fines académicos.',
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}