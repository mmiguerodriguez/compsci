El código que resuelve el problema del enunciado está en el archivo src/jambotubo.cpp.
Para compilarlo se debe ejecutar el comando 
	make
en la consola.

Al ejecutarlo se le debe pasar un parámetro que indique cuál algoritmo se desea utilizar entre las siguientes opciones:
	- FB: Fuerza bruta
	- BT: Backtracking
	- BT-F: Backtracking solamente con poda por factibilidad.
	- BT-O: Backtracking solamente con poda por optimalidad.
	- DP: Programación dinámica.

Además se debe pasar la instancia por entrada estándar. Por ejemplo, para ejecutar backtracking solamente con podas por factibilidad en una instancia INST1.TXT se debe correr el siguiente comando:
	cat INST1.txt | ./jambotubo BT-F
La salida del programa es doble. Por la salida estándar se devuelve lo pedido por el enunciado. Por la STDERR se devuelve el tiempo de ejecución del algoritmo.

La generación de instancias y corrida de experimentos de manera secuencia está programada en Python utilizando Jupyter Lab (https://jupyter.org/). Para ver los notebooks se debe instalar Jupyter Labs siguiendo las instrucciones en su web. Se recomienda seguir los pasos de instalación utilizando pip3.

Una vez instalado Jupyter Lab, abrir una consola en la carpeta python y correr el comando:
	jupyter lab
	
Dentro de las notebooks de jupyter se pueden generar distintas instancias con o sin resistencia variable
para poder verificar distintas propiedades de los algoritmos desarrollados.
