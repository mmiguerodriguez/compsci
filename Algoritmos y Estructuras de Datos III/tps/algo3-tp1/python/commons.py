import math, subprocess
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import random
from IPython.display import display, clear_output
import os

def leer_instancia(path_instancia):
    with open(path_instancia, "r") as f:
        return f.read();

def ejecutar_experimento(metodo, archivo_instancia):
    # Leer archivo de la instancia.
    instancia = leer_instancia(archivo_instancia)
    
    # Crear proceso para ejecutar el codigo.
    process = subprocess.Popen(["../src/jambotubo", metodo], stderr=subprocess.PIPE, stdout=subprocess.PIPE, stdin=subprocess.PIPE, universal_newlines = True)

    # Poner la instancia en la entrada estandar.
    process.stdin.write(instancia)
    process.stdin.flush()

    # Correr experimento.
    exit_code = process.wait()

    # Verificar que el proceso no fallo.
    if exit_code != 0: print(F"Hubo un error en la experimentacion para el algoritmo: {metodo} con la instancia {archivo_instancia}.")
    # Leer salida de STDERR con los tiempos de ejecucion de cada metodo.
    tiempo_de_ejecucion = float(process.stderr.read());
    
    process.stdin.close();
    process.stdout.close();
    process.stderr.close();
    
    return tiempo_de_ejecucion;

def save_instance(dataset, instance_name, J, P):
    with open(F"instancias/{dataset}/{instance_name}.txt", "w") as f:
        # printeamos n y resistencia_total
        print(J[0], J[1], file=f)
        for product in P: 
            # printeamos peso y resistencia
            print(product[0], product[1], file=f)

def graficar(times, algorithm, name):
    # Data for plotting
    y = []
    x = [i*1 for i in range(1, len(times) + 1)] # Cantidad de productos
    complexity = ""

    # k = 0.5
    
    if algorithm == "FB":
        y = [(i*1) * 2**(i*1) for i in range(1, len(times) + 1)]
        complexity = "n * 2^n"
    elif algorithm == "BT" or algorithm == "BT-F" or algorithm == "BT-O":
        y = [(i*1)**2 * 2**(i*1) for i in range(1, len(times) + 1)]
        complexity = "n^2 * 2^n"
    else:
        y = [(i * 1) * (i * 5) for i in range(1, len(times) + 1)]
        complexity = "n * r"
    
    # 
    y = [(np.mean(times)/np.mean(y)) * e for e in y]
    
    fig, ax1 = plt.subplots()

    color = 'tab:blue'
    ax1.set_xlabel('Cantidad de productos')
    ax1.set_ylabel('Tiempo (ms)')
    plot_tiempos, = ax1.plot(x, times, color=color, marker='o', linestyle="None", label='tiempo')
    ax1.tick_params(axis='y')

    color = 'tab:orange'
    ax1.set_label(complexity)
    plot_n, = ax1.plot(x, y, color=color, linestyle='-', label=complexity)
#     ax1.axes.yaxis.set_visible(False)

    ax1.legend((plot_tiempos, plot_n), (algorithm, complexity), loc=0)
    fig.savefig(name + ".png")
    plt.show()
    
def graficar_rvar(times, algorithm, name):
    # Data for plotting
    y = []
    x = [i*1 for i in range(1, len(times) + 1)] # Cantidad de productos
    complexity = ""

    # k = 0.5
    
    if algorithm == "FB":
        y = [(i*1) * 2**(i*1) for i in range(1, len(times) + 1)]
        complexity = "n * 2^n"
    elif algorithm == "BT" or algorithm == "BT-F" or algorithm == "BT-O":
        y = [(i*1)**2 * 2**(i*1) for i in range(1, len(times) + 1)]
        complexity = "n^2 * 2^n"
    else:
        y = [(i * 1) * (i * 5) for i in range(1, len(times) + 1)]
        complexity = "n * r"
    
    # 
    y = [(np.mean(times)/np.mean(y)) * e for e in y]
    
    fig, ax1 = plt.subplots()

    x = [i * 100 for i in x]
    
    color = 'tab:blue'
    ax1.set_xlabel('Resistencias')
    ax1.set_ylabel('Tiempo (ms)')
    plot_tiempos, = ax1.plot(x, times, color=color, marker='o', linestyle="None", label='tiempo')
    ax1.tick_params(axis='y')

    color = 'tab:orange'
    ax1.set_label(complexity)
    plot_n, = ax1.plot(x, y, color=color, linestyle='-', label=complexity)
#     ax1.axes.yaxis.set_visible(False)

    ax1.legend((plot_tiempos, plot_n), (algorithm, complexity), loc=0)
    fig.savefig(name + ".png")
    plt.show()
    
def generar_instancias(nombre, seed):
    random.seed(seed)

    P = []
    for i in range(1, 101):
        J = [i * 1, i * 5] # generar jambotubo
        for j in range(1): # generar lista de productos 
            weight = random.randint(1, i * 10)
            resistance = random.randint(1, i * 10)
            P.append([weight, resistance])

        prefijo = ""
        if i < 10:
            prefijo = "00"
        elif i < 100:
            prefijo = "0"

        save_instance(nombre, F'{prefijo}{i}_{J[0]}_{J[1]}', J, P);
        
def generar_instancias_rvar(nombre, seed):
    random.seed(seed)

    P = []
    for i in range(1, 101):
        J = [15, i * 100] # generar jambotubo
        for j in range(1): # generar lista de productos 
            weight = random.randint(1, i * 10)
            resistance = random.randint(1, i * 10)
            P.append([weight, resistance])

        prefijo = ""
        if i < 10:
            prefijo = "00"
        elif i < 100:
            prefijo = "0"

        save_instance(nombre, F'{prefijo}{i}_{J[0]}_{J[1]}', J, P);
        
def correr_experimento(algorithm, instancia, cant_experimentos, T):
    print(algorithm)
    instancias = os.listdir(F'instancias/{instancia}')
    instancias.sort()
 
    result = []
    numero = 1
    
    for i in range(cant_experimentos):
        clear_output(wait=True) # Voy mostrando que experimento se esta ejecutando.
        display('Ejecutando experimento: ' + str(numero) + "/" + str(cant_experimentos))
        numero += 1

        tiempos = [] # Ejecutamos el experimento T veces y obtenemos la mediana.
        for k in range(0, T):
            tiempos.append(ejecutar_experimento(algorithm, F'instancias/{instancia}/{instancias[i]}'));
        tiempo = np.median(tiempos);
        result.append(tiempo);

    return result