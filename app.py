# IMPORTACIONES
from flask import Flask, request, jsonify
from flask_cors import CORS
from arbol import ArbolBinario

app = Flask(__name__)
CORS(app)

arbol = None


@app.route('/insertar', methods=['POST'])
def insertar_nodo():
    global arbol

    datos = request.get_json()

    if not datos:
        return jsonify({
            'exito': False,
            'mensaje': 'No se recibieron datos'
        }), 400

    valor = datos.get('valor')
    lado = datos.get('lado')
    padre = datos.get('padre')

    if valor is None or valor == '':
        return jsonify({
            'exito': False,
            'mensaje': 'Debe ingresar un valor para el nodo'
        }), 400

    if arbol is None:
        arbol = ArbolBinario()

    exito, mensaje = arbol.insertar(valor, lado, padre)

    return jsonify({
        'exito': exito,
        'mensaje': mensaje,
        'arbol': arbol.a_diccionario(arbol.raiz)
    }), 200


@app.route('/arbol', methods=['GET'])
def obtener_arbol():
    global arbol

    if arbol is None or arbol.raiz is None:
        return jsonify({
            'arbol': None,
            'mensaje': 'El árbol está vacío'
        }), 200

    return jsonify({
        'arbol': arbol.a_diccionario(arbol.raiz)
    }), 200


@app.route('/recorridos', methods=['GET'])
def obtener_recorridos():
    global arbol

    if arbol is None or arbol.raiz is None:
        return jsonify({
            'error': 'El árbol está vacío'
        }), 400

    return jsonify({
        'preorden': arbol.obtener_preorden(),
        'inorden': arbol.obtener_inorden(),
        'postorden': arbol.obtener_postorden()
    }), 200


@app.route('/reconstruir', methods=['POST'])
def reconstruir_arbol():
    global arbol

    datos = request.get_json()

    if not datos:
        return jsonify({
            'error': 'No se recibieron datos'
        }), 400

    preorden = datos.get('preorden')
    inorden = datos.get('inorden')

    if not preorden or not inorden:
        return jsonify({
            'error': 'Faltan datos de preorden o inorden para reconstruir'
        }), 400

    if len(preorden) != len(inorden):
        return jsonify({
            'error': 'Preorden e inorden deben tener la misma cantidad de elementos'
        }), 400

    arbol = ArbolBinario()
    arbol.reconstruir(preorden, inorden)

    return jsonify({
        'mensaje': 'Árbol reconstruido exitosamente',
        'arbol': arbol.a_diccionario(arbol.raiz)
    }), 200


@app.route('/limpiar', methods=['DELETE'])
def limpiar_arbol():
    global arbol

    arbol = None

    return jsonify({
        'exito': True,
        'mensaje': 'Árbol limpiado correctamente',
        'arbol': None
    }), 200


# INICIAR EL SERVIDOR
if __name__ == '__main__':
    app.run(debug=True)