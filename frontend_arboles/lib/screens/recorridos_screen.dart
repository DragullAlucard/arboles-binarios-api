import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/arbol_service.dart';

class RecorridosScreen extends StatefulWidget {
  const RecorridosScreen({super.key});

  @override
  State<RecorridosScreen> createState() => _RecorridosScreenState();
}

class _RecorridosScreenState extends State<RecorridosScreen> {
  List<dynamic> preorden = [];
  List<dynamic> inorden = [];
  List<dynamic> postorden = [];

  String mensaje = '';
  bool cargando = false;

  Future<void> cargarRecorridos() async {
    setState(() {
      cargando = true;
      mensaje = '';
    });

    try {
      final respuesta = await ArbolService.obtenerRecorridos();

      setState(() {
        preorden = respuesta['preorden'] ?? [];
        inorden = respuesta['inorden'] ?? [];
        postorden = respuesta['postorden'] ?? [];
        mensaje = 'Recorridos actualizados correctamente';
      });
    } catch (e) {
      setState(() {
        mensaje =
            'No se pudieron obtener los recorridos. Verifique que exista un árbol.';
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  void copiarRecorrido(String titulo, List<dynamic> datos) {
    if (datos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$titulo no tiene datos para copiar')),
      );
      return;
    }

    final textoCopiado = datos.join(',');

    Clipboard.setData(
      ClipboardData(text: textoCopiado),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$titulo copiado: $textoCopiado'),
      ),
    );
  }

  Widget tarjetaRecorrido({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required List<dynamic> datos,
  }) {
    final contenido = datos.isEmpty ? 'Sin datos' : datos.join(' → ');

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(icono),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(height: 4),
                      Text(
                        descripcion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  contenido,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: datos.isEmpty
                    ? null
                    : () => copiarRecorrido(titulo, datos),
                icon: const Icon(Icons.copy),
                label: const Text('Copiar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cargarRecorridos();
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final esMovil = ancho < 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorridos del Árbol'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                Icon(
                  Icons.route,
                  size: esMovil ? 60 : 80,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 12),

                Text(
                  'Recorridos del Árbol Binario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 26 : 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Visualiza y copia los recorridos Preorden, Inorden y Postorden del árbol actual.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 15 : 17,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 25),

                FilledButton.icon(
                  onPressed: cargando ? null : cargarRecorridos,
                  icon: cargando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label:
                      Text(cargando ? 'Cargando...' : 'Actualizar recorridos'),
                ),

                const SizedBox(height: 18),

                if (mensaje.isNotEmpty)
                  Card(
                    color: mensaje.contains('No se pudieron')
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        mensaje,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mensaje.contains('No se pudieron')
                              ? Theme.of(context).colorScheme.onErrorContainer
                              : Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                tarjetaRecorrido(
                  titulo: 'Preorden',
                  descripcion:
                      'Primero visita la raíz, luego el subárbol izquierdo y finalmente el derecho.',
                  icono: Icons.looks_one,
                  datos: preorden,
                ),

                tarjetaRecorrido(
                  titulo: 'Inorden',
                  descripcion:
                      'Primero visita el subárbol izquierdo, luego la raíz y después el derecho.',
                  icono: Icons.looks_two,
                  datos: inorden,
                ),

                tarjetaRecorrido(
                  titulo: 'Postorden',
                  descripcion:
                      'Primero visita los subárboles y al final visita la raíz.',
                  icono: Icons.looks_3,
                  datos: postorden,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}