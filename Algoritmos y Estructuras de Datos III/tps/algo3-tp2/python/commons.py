import subprocess
import random

def generar_instancias_random(cant_vertices):
    for i in range(2, cant_vertices + 1):
        texto = ''
        m = int((i*(i-1))/2)
        f = open(F"inputs_procesados/incrementado_{i}.txt", "w")
        texto += F"{i} {m}\n"
        
        nodo = 1
        conexion = 2
        for j in range(m):
            peso = random.randint(1, 50)
            if j == m - 1:
                texto += F"{nodo} {conexion} {peso}"
            else:
                texto += F"{nodo} {conexion} {peso}\n"
            if conexion == i:
                nodo += 1
                conexion = nodo + 1
            else:
                conexion += 1

        print(texto, file=f)
        
def generar_instancias_performance(cant_vertices, cant_grafos):
    v = cant_vertices
    for i in range(cant_grafos):
        texto = ''
        m = int((v*(v-1))/2)
        f = open(F"inputs_procesados/randoms/random_{v}_vertices_{i}.txt", "w")
        texto += F"{v} {m}\n"
        
        nodo = 1
        conexion = 2
        for j in range(m):
            peso = random.randint(1, 50)
            if j == m - 1:
                texto += F"{nodo} {conexion} {peso}"
            else:
                texto += F"{nodo} {conexion} {peso}\n"
            if conexion == v:
                nodo += 1
                conexion = nodo + 1
            else:
                conexion += 1

        print(texto, file=f)

def ejecutar(filename, algoritmo, memoria_tabu=-1, cant_vecinos=-1, cant_iteraciones=-1):
    parametros = [] 
        
    parametros.append("../src/main")
    parametros.append(algoritmo) # VMC, AMC, AGM, TS, TSA
    parametros.append(str(memoria_tabu))
    parametros.append(str(cant_vecinos))
    parametros.append(str(cant_iteraciones))
    
    process = subprocess.Popen(parametros, stderr=subprocess.PIPE, stdout=subprocess.PIPE, stdin=subprocess.PIPE, universal_newlines = True)
    
    entrada = ''
    file = f"inputs_procesados/{filename}.txt"
    with open(file, 'r') as fp:
        line = fp.readline()
        while line:
            entrada += line
            line = fp.readline()
    

    output = process.communicate(input=entrada)
    res = output[1].split('\n')[0].split(' ')
    
    tiempo = float(res[0])
    peso = int(res[1])
    
    return [tiempo, peso] # [tiempo que se tarda, peso del camino]