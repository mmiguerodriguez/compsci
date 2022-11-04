# TP1 Métodos Numéricos - Ranking Deportivo

## Instrucciones

En `src/` está el código de C++. Ahí está la implementación de los algoritmos pedidos.

En `notebooks/` están los jupyter notebooks utilizados para correr la experimentación en sobre la implementación de C++. 

Versión de Python >= 3.6.5


## Creación de un entorno virtual de python

### Con virtualenvwrapper

```
sudo apt install virtualenvwrapper
```

Luego, se sugiere agregar las siguientes líneas al bashrc. 

```
export PATH=/usr/local/bin:$PATH
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
```

Hacer eso, **REINICIAR LA CONSOLA** y luego...

```
mkvirtualenv metnum-tp1
```

o si ya creaste un enviroment

```
workon metnum-tp1
```

## Instalación de las depencias
```
pip3 install -r requirements.txt
```

## Correr notebooks de jupyter

```
cd notebooks
jupyter lab
```
o  notebook
```
jupyter notebook
```


## Compilación
Ejecutar la primera celda de los notebooks `TP1X.ipynb` o seguir los siguientes pasos:

- Compilar el código C++ con cmake
```
cd src
cmake -DCMAKE_BUILD_TYPE=Release .
make
```

## Correr el codigo de c++ compilado

Luego de compilar el codigo lo podemos ejecutar el archivo ejecutable de la siguiente manera. 
``` 
./tp1 {metodo de calculo} {archivo de entrada} {archivo de salida}
``` 

- Los metodos de calculo posible son: **0** (Colley's Matrix Method), **1** (Win Percentage) y **2** (Bonus Point)