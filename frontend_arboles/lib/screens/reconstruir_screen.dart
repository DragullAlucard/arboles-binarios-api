import 'package:flutter/material.dart';
import '../services/arbol_service.dart';

class ReconstruirScreen extends StatefulWidget {
  const ReconstruirScreen({super.key});

  @override
  State<ReconstruirScreen> createState() => _ReconstruirScreenState();
}

class _ReconstruirScreenState extends State<ReconstruirScreen> {
  final TextEditingController preordenController = TextEditingController();
  final TextEditingController inordenController = TextEditingController();

  String mensaje = '';
  Map<String, dynamic>? arbol;
  bool cargando = false;

  List<String> convertirLista(String texto) {
    return texto
        .split(',')
        .map((valor) => valor.trim())
        .where((valor) => valor.isNotEmpty)
        .toList();
  }

  Future<void> reconstruirArbol() async {
    final preorden = convertirLista(preordenController.text);
    final inorden = convertirLista(inordenController.text);

    if (preorden.isEmpty || inorden.isEmpty) {
      setState(() {
        mensaje = 'Ingrese preorden e inorden';
      });
      return;
    }

    if (preorden.length != inorden.length) {
      setState(() {
        mensaje = 'Preorden e inorden deben tener la misma cantidad de valores';
      });
      return;
    }

    setState(() {
      cargando = true;
      mensaje = '';
    });

    try {
      final respuesta = await ArbolService.reconstruirArbol(
        preorden: preorden,
        inorden: inorden,
      );

      setState(() {
        mensaje = respuesta['mensaje'] ?? 'Árbol reconstruido correctamente';
        arbol = respuesta['arbol'];
      });
    } catch (e) {
      setState(() {
        mensaje = 'Error al reconstruir el árbol';
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  void limpiarCampos() {
    setState(() {
      preordenController.clear();
      inordenController.clear();
      mensaje = '';
      arbol = null;
    });
  }

  Widget mostrarArbol(Map<String, dynamic>? nodo) {
    if (nodo == null) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          'Árbol vacío',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(150),
      minScale: 0.45,
      maxScale: 3,
      child: SizedBox(
        height: 560,
        width: 1400,
        child: CustomPaint(
          painter: ArbolPainter(nodo),
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
        title: const Text('Reconstrucción del Árbol'),
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
                Icon(
                  Icons.restart_alt,
                  size: esMovil ? 60 : 80,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 12),

                Text(
                  'Reconstruir Árbol Binario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 26 : 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Ingrese los recorridos Preorden e Inorden separados por comas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: esMovil ? 15 : 17,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 25),

                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: preordenController,
                          decoration: InputDecoration(
                            labelText: 'Preorden',
                            hintText: 'Ejemplo: A,B,C,D',
                            prefixIcon: const Icon(Icons.looks_one),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          controller: inordenController,
                          decoration: InputDecoration(
                            labelText: 'Inorden',
                            hintText: 'Ejemplo: C,B,A,D',
                            prefixIcon: const Icon(Icons.looks_two),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: cargando ? null : reconstruirArbol,
                              icon: cargando
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.account_tree),
                              label: Text(
                                cargando
                                    ? 'Reconstruyendo...'
                                    : 'Reconstruir árbol',
                              ),
                            ),

                            ElevatedButton.icon(
                              onPressed: limpiarCampos,
                              icon: const Icon(Icons.cleaning_services),
                              label: const Text('Limpiar'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        if (mensaje.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: mensaje.contains('Error') ||
                                      mensaje.contains('Ingrese') ||
                                      mensaje.contains('deben')
                                  ? Theme.of(context)
                                      .colorScheme
                                      .errorContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              mensaje,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mensaje.contains('Error') ||
                                        mensaje.contains('Ingrese') ||
                                        mensaje.contains('deben')
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Árbol Reconstruido',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Puedes mover y acercar el árbol usando el mouse o los dedos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 560,
                          child: mostrarArbol(arbol),
                        ),
                      ],
                    ),
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

class ArbolPainter extends CustomPainter {
  final Map<String, dynamic> arbol;

  ArbolPainter(this.arbol);

  final Paint lineaPaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

  final Paint sombraPaint = Paint()
    ..color = Colors.black.withOpacity(0.20)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  Color colorPorNivel(int nivel) {
    final colores = [
      Colors.greenAccent,
      Colors.lightBlueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.tealAccent,
    ];

    return colores[nivel % colores.length];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final separacionInicial = size.width / 3.3;

    _dibujarNodo(
      canvas,
      arbol,
      size.width / 2,
      60,
      separacionInicial,
      0,
    );
  }

  void _dibujarNodo(
    Canvas canvas,
    Map<String, dynamic>? nodo,
    double x,
    double y,
    double separacion,
    int nivel,
  ) {
    if (nodo == null) return;

    const double radio = 25;
    const double distanciaVertical = 95;
    const double separacionMinima = 55;

    final izquierdo = nodo['izquierdo'];
    final derecho = nodo['derecho'];

    final nuevaSeparacion =
        (separacion * 0.56) < separacionMinima ? separacionMinima : separacion * 0.56;

    if (izquierdo != null) {
      final xIzq = x - separacion;
      final yIzq = y + distanciaVertical;

      canvas.drawLine(
        Offset(x, y + radio),
        Offset(xIzq, yIzq - radio),
        lineaPaint,
      );

      _dibujarNodo(
        canvas,
        izquierdo,
        xIzq,
        yIzq,
        nuevaSeparacion,
        nivel + 1,
      );
    }

    if (derecho != null) {
      final xDer = x + separacion;
      final yDer = y + distanciaVertical;

      canvas.drawLine(
        Offset(x, y + radio),
        Offset(xDer, yDer - radio),
        lineaPaint,
      );

      _dibujarNodo(
        canvas,
        derecho,
        xDer,
        yDer,
        nuevaSeparacion,
        nivel + 1,
      );
    }

    final nodoPaint = Paint()
      ..color = colorPorNivel(nivel)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(x + 3, y + 4),
      radio,
      sombraPaint,
    );

    canvas.drawCircle(
      Offset(x, y),
      radio,
      nodoPaint,
    );

    canvas.drawCircle(
      Offset(x, y),
      radio,
      Paint()
        ..color = Colors.black.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    textPainter.text = TextSpan(
      text: nodo['valor'].toString(),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}