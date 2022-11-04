// Ejercicio 0.

// Correccion en anilloCero
let anilloCero = { 
  dato: 0,
  agregar: function(valor) {
    let nuevo = Object.create(this);

    nuevo.dato = valor;
    nuevo.siguiente = this.siguiente;
    this.siguiente = nuevo;

    return this;
  },
  toString: function() {
    let start = this;
    let actual = this.siguiente;
    let res = this.dato;

    while (actual != start) {
      res += ' ↝ ' + actual.dato;
      actual = actual.siguiente;
    }

    return res;
  }
};

anilloCero.siguiente = anilloCero;

// Ejercicio 1.
function Anillo(d) {
  console.log('d', d);
  this.dato = d;
  this.siguiente = this;

  return this;
};

// Correcciones reutilizando agregar y toString definidos
// anteriormente en anilloCero
Anillo.prototype.agregar = anilloCero.agregar;

// Ejercicio 2
Anillo.prototype.toString = anilloCero.toString; 

// Ejercicio 4
Anillo.prototype.map = function (f) {
  let nuevo_start = new Anillo(f(this.dato));
  nuevo_start.siguiente = nuevo_start;

  let pos_orig = this.siguiente;
  let nuevo_anillo = nuevo_start.siguiente;

  while(pos_orig != this) {
    nuevo_anillo.agregar(f(pos_orig.dato));
    nuevo_anillo = nuevo_anillo.siguiente;
    pos_orig = pos_orig.siguiente;
  }

  return nuevo_start
};

Anillo.prototype.copiar = function () {
  return this.map((d) => d);
};

Anillo.prototype.cantidad = function () { 
  let res = 1;
  let actual = this.siguiente;

  while (actual != this) {
    res++;
    actual = actual.siguiente;
  }

  return res;
};

// Ejercicio 5
Anillo.prototype.ponerAnteriores = function () {
  let start = this;
  let actual = this;

  do {
    actual.siguiente.anterior = actual;

    actual.agregar = function(d) {
      // El this adentro referencia al objecto "actual" que estamos queriendo modificar,
      // osea el que va a llamar a agregar en un futuro.
      let nuevo_nodo = new Anillo(d);

      this.siguiente.anterior = nuevo_nodo;
      nuevo_nodo.anterior = this;
    
      nuevo_nodo.siguiente = this.siguiente;
      this.siguiente = nuevo_nodo;
    
      return this;
    };

    actual = actual.siguiente;
  } while (actual != start);

  return this;
}

let f = function(d) {
  d + 2;
};

let crearAnillo = function(d) {
  let a = new Anillo(d);  
  return a;
};

function calcularResultado() {
  let res = "";
  let anilloUno = new Anillo(1);
  anilloUno.siguiente = anilloUno;

  // Object.setPrototypeOf(anilloUno, anilloCero);
  res += anilloUno.agregar(3).agregar(2)+"<br />"+anilloUno.siguiente; //1 ↝ 2 ↝ 3<br />2 ↝ 3 ↝ 1
  res +="<br />"+(crearAnillo(0)).agregar(2).agregar(1)+"<br />"+anilloCero.siguiente; //0 ↝ 1 ↝ 2<br />0
  res +="<br />"+(crearAnillo(0)).agregar(2).agregar(1).map(e => e+1);//1 ↝ 2 ↝ 3
  res +="<br />"+(crearAnillo(0)).agregar(1).map(e => e+4);//4 ↝ 5
  res +="<br />"+(crearAnillo(1)).map(e => e*2);//2
  let anilloDos = crearAnillo(2).agregar(2);
  let anilloCopia = anilloDos.copiar();
  anilloDos.agregar(2);
  anilloCopia.agregar(1);
  res +="<br />"+anilloDos;//2 ↝ 2 ↝ 2
  res +="<br />"+anilloCopia;//2 ↝ 1 ↝ 2
  res +="<br />"+anilloCopia;//2 ↝ 1 ↝ 2
  res +="<br />"+anilloDos.cantidad();//3
  res +="<br />"+crearAnillo(0).agregar(3).agregar(2).ponerAnteriores().agregar(1).siguiente.anterior;//0 ↝ 1 ↝ 2 ↝ 3
  let anilloLetras = (crearAnillo("a")).agregar("d").agregar("c");
  anilloLetras.siguiente.ponerAnteriores();
  anilloLetras.agregar("b");
  res +="<br />"+anilloLetras.siguiente.anterior.dato;//a 
  anilloLetras.anterior.agregar("e");
  res +="<br />"+anilloLetras;//a ↝ b ↝ c ↝ d ↝ e
  res +="<br />"+anilloDos.agregar(2).siguiente.anterior;//undefined
  res +="<br />"+(crearAnillo(1)).agregar(2).siguiente.anterior;//undefined

  document.body.innerHTML = res;
  return res;
}
