#METODOS PARA ACUMULAR LOS VALORES EN UNA LISTA Y METODO RECONSTRUCCION PARA ESTA CLASE

class Nodo:
    def __init__(self, valor, nivel=1):
        self.valor = valor
        self.izquierdo = None
        self.derecho = None
        self.nivel = nivel

class ArbolBinario:
    def __init__(self):
        self.raiz = None
        self.MAX_NIVEL = 5

    def insertar(self, valor, lado, padre=None):
        if self.raiz is None:
            self.raiz = Nodo(valor)
            return True, "Raiz insertada correctamente"
        else:
            return self._insertar_recursivo(self.raiz, valor, lado, padre)

    def _insertar_recursivo(self, nodo, valor, lado, padre):
        if nodo.nivel >= self.MAX_NIVEL:
            return False, "Se alcanzo el nivel maximo (5)"

        if str(nodo.valor) == str(padre):
            if lado == "izquierdo":
                if nodo.izquierdo is None:
                    nodo.izquierdo = Nodo(valor, nodo.nivel + 1)
                    return True, "Nodo insertado a la izquierda"
                else:
                    return False, "Ya existe un nodo a la izquierda"
            else:
                if nodo.derecho is None:
                    nodo.derecho = Nodo(valor, nodo.nivel + 1)
                    return True, "Nodo insertado a la derecha"
                else:
                    return False, "Ya existe un nodo a la derecha"

        resultado = None
        if nodo.izquierdo:
            resultado = self._insertar_recursivo(nodo.izquierdo, valor, lado, padre)
            if resultado and resultado[0]:
                return resultado

        if nodo.derecho:
            resultado = self._insertar_recursivo(nodo.derecho, valor, lado, padre)
            if resultado and resultado[0]:
                return resultado

        return False, "Nodo padre no encontrado"

    def a_diccionario(self, nodo):
        if nodo is None:
            return None
        return {
            "valor": nodo.valor,
            "nivel": nodo.nivel,
            "izquierdo": self.a_diccionario(nodo.izquierdo),
            "derecho": self.a_diccionario(nodo.derecho)
        }


    def obtener_preorden(self):
        resultado = []
        self._preorden_recursivo(self.raiz, resultado)
        return resultado

    def _preorden_recursivo(self, nodo, lista):
        if nodo is not None:
            lista.append(nodo.valor)
            self._preorden_recursivo(nodo.izquierdo, lista)
            self._preorden_recursivo(nodo.derecho, lista)

    def obtener_inorden(self):
        resultado = []
        self._inorden_recursivo(self.raiz, resultado)
        return resultado

    def _inorden_recursivo(self, nodo, lista):
        if nodo is not None:
            self._inorden_recursivo(nodo.izquierdo, lista)
            lista.append(nodo.valor)
            self._inorden_recursivo(nodo.derecho, lista)

    def obtener_postorden(self):
        resultado = []
        self._postorden_recursivo(self.raiz, resultado)
        return resultado

    def _postorden_recursivo(self, nodo, lista):
        if nodo is not None:
            self._postorden_recursivo(nodo.izquierdo, lista)
            self._postorden_recursivo(nodo.derecho, lista)
            lista.append(nodo.valor)


    def reconstruir(self, lista_preorden, lista_inorden):
        """Reconstruye el arbol y sobreescribe la raiz actual."""
        self.raiz = self._reconstruir_recursivo(lista_preorden, lista_inorden, nivel=1)

    def _reconstruir_recursivo(self, preorden, inorden, nivel):
        if not preorden or not inorden:
            return None

        valor_raiz = preorden[0]
        nodo = Nodo(valor_raiz, nivel)

        try:
            indice_raiz = inorden.index(valor_raiz)
        except ValueError:
           
            return None

        nodo.izquierdo = self._reconstruir_recursivo(
            preorden[1 : 1 + indice_raiz], 
            inorden[:indice_raiz], 
            nivel + 1
        )
        
        nodo.derecho = self._reconstruir_recursivo(
            preorden[1 + indice_raiz :], 
            inorden[indice_raiz + 1 :], 
            nivel + 1
        )

        return nodo

  



