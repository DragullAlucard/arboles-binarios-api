import 'package:flutter/material.dart';
import '../services/arbol_service.dart';

class ConstruirScreen extends StatefulWidget {
  const ConstruirScreen({super.key});

  @override
  State<ConstruirScreen> createState() => _ConstruirScreenState();
}

class _ConstruirScreenState extends State<ConstruirScreen> {
  final TextEditingController valorController = TextEditingController();
  final TextEditingController padreController = TextEditingController();

  String ladoSeleccionado = 'izquierdo';
  String mensaje = '';
  Map<String, dynamic>? arbol;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarArbolGuardado();
  }

  Future<void> cargarArbolGuardado() async {
    try {
      final respuesta = await ArbolService.obtenerArbol();

      if (!mounted) return;

      setState(() {
        arbol = respuesta['arbol'];
        mensaje = respuesta['mensaje']?.toString() ?? '';
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = 'Error al cargar árbol guardado';
        cargando = false;
      });
    }
  }

  Future<void> insertarNodo() async {
    final valor = valorController.text.trim();
    final padre = padreController.text.trim();

    if (valor.isEmpty) {
      setState(() {
        mensaje = 'Ingrese un valor';
      });
      return;
    }

    try {
      final respuesta = await ArbolService.insertarNodo(
        valor: valor,
        lado: ladoSeleccionado,
        padre: padre,
      );

      setState(() {
        mensaje = respuesta['mensaje'].toString();
        arbol = respuesta['arbol'];
      });

      valorController.clear();
      padreController.clear();
    } catch (e) {
      setState(() {
        mensaje = 'Error al conectar con Flask';
      });
    }
  }

  Future<void> limpiarArbol() async {
    try {
      final respuesta = await ArbolService.limpiarArbol();

      setState(() {
        mensaje = respuesta['mensaje'].toString();
        arbol = null;
      });

      valorController.clear();
      padreController.clear();
    } catch (e) {
      setState(() {
        mensaje = 'Error al limpiar árbol';
      });
    }
  }

  Widget mostrarArbol(Map<String, dynamic>? nodo) {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (nodo == null) {
      return const Center(
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
  void dispose() {
    valorController.dispose();
    padreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Construcción del Árbol'),
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
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Agregar Nodo',
                          style: TextStyle(
                            fontSize: ancho < 600 ? 22 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          controller: valorController,
                          decoration: InputDecoration(
                            labelText: 'Valor del nodo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            prefixIcon: const Icon(Icons.account_tree),
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: padreController,
                          decoration: InputDecoration(
                            labelText: 'Nodo padre (vacío para raíz)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            prefixIcon: const Icon(Icons.link),
                          ),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: ladoSeleccionado,
                          decoration: InputDecoration(
                            labelText: 'Lado',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'izquierdo',
                              child: Text('Izquierdo'),
                            ),
                            DropdownMenuItem(
                              value: 'derecho',
                              child: Text('Derecho'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              ladoSeleccionado = value;
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: insertarNodo,
                              icon: const Icon(Icons.add),
                              label: const Text('Insertar nodo'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 18,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: limpiarArbol,
                              icon: const Icon(Icons.delete),
                              label: const Text('Limpiar árbol'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          mensaje,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
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
                          'Visualización del Árbol',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Puedes acercar y mover el árbol con el mouse o los dedos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
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

    final nuevaSeparacion = (separacion * 0.56) < separacionMinima
        ? separacionMinima
        : separacion * 0.56;

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
        Map<String, dynamic>.from(izquierdo),
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
        Map<String, dynamic>.from(derecho),
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