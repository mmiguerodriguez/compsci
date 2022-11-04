# Tus Libros

Inicializar servidor en un nuevo Workspace
```
port := 8080.
server := TusLibrosRestInterface listeningOn: port.
```

Abrir la ventana de login:
```
LoginWindow open.
```

En caso de querer hacer un cambio se debe destruir el servidor e inicializar uno nuevo y cerrar todas
las ventanas ya abiertas para evitar errores.
```
server destroy.
```

Una vez realizado este paso, el resto de las instrucciones se pueden hacer directamente
desde la interfaz visual.

### Login
Para iniciar sesion con un usuario.
Cuenta valida: username: validUser | password: validUserPassword

### Catalog
Seleccionar los libros que queremos agregar al carrito y agregarlos (de a 1).
Existe la posibilidad de remover un libro.
Purchase history nos lleva a la ventana de historial de compras.
Checkout efectua la compra de los libros seleccionados, para luego mostrarnos el ticket..

### Ticket
Muestra la lista de los libros comprados.
Se puede cerrar sesion haciendo click en logout.
Para realizar una nueva compra hay que cerrar la ventana del ticket.

### Purchase History
Historial de compras del usuario.
