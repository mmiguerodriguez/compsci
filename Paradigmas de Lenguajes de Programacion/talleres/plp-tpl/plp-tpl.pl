%% Autómatas de ejemplo. Si agregan otros, mejor.
ejemplo(1, a(s1, [sf], [(s1, a, sf)])).
ejemplo(2, a(si, [si], [(si, a, si)])).
ejemplo(3, a(si, [si], [])).
ejemplo(4, a(s1, [s2, s3], [(s1, a, s1), (s1, a, s2), (s1, b, s3)])).
ejemplo(5, a(s1, [s2, s3], [(s1, a, s1), (s1, b, s2), (s1, c, s3), (s2, c, s3)])).
ejemplo(6, a(s1, [s3], [(s1, b, s2), (s3, n, s2), (s2, a, s3)])).
ejemplo(7, a(s1, [s2], [(s1, a, s3), (s3, a, s3), (s3, b, s2), (s2, b, s2)])).
ejemplo(8, a(s1, [sf], [(s1, a, s2), (s2, a, s3), (s2, b, s3), (s3, a, s1), (s3, b, s2), (s3, b, s4), (s4, f, sf)])). % No deterministico :)
ejemplo(9, a(s1, [s1], [(s1, a, s2), (s2, b, s1)])).
ejemplo(10, a(s1, [s10, s11], 
        [(s2, a, s3), (s4, a, s5), (s9, a, s10), (s5, d, s6), (s7, g, s8), (s15, g, s11), (s6, i, s7), (s13, l, s14), (s8, m, s9), (s12, o, s13), (s14, o, s15), (s1, p, s2), (s3, r, s4), (s2, r, s12), (s10, s, s11)])).

ejemploMalo(1, a(s1, [s2], [(s1, a, s1), (s1, b, s2), (s2, b, s2), (s2, a, s3)])). %s3 es un estado sin salida.
ejemploMalo(2, a(s1, [sf], [(s1, a, s1), (sf, b, sf)])). %sf no es alcanzable.
ejemploMalo(3, a(s1, [s2, s3], [(s1, a, s3), (s1, b, s3)])). %s2 no es alcanzable.
ejemploMalo(4, a(s1, [s3], [(s1, a, s3), (s2, b, s3)])). %s2 no es alcanzable.
ejemploMalo(5, a(s1, [s3, s2, s3], [(s1, a, s2), (s2, b, s3)])). %Tiene un estado final repetido.
ejemploMalo(6, a(s1, [s3], [(s1, a, s2), (s2, b, s3), (s1, a, s2)])). %Tiene una transición repetida.
ejemploMalo(7, a(s1, [], [(s1, a, s2), (s2, b, s3)])). %No tiene estados finales.

% Proyectores
inicialDe(a(I, _, _), I).
finalesDe(a(_, F, _), F).
transicionesDe(a(_, _, T), T).

% Predicados pedidos

% 1) esDeterministico(+Automata)
% Un automata es deterministico, si no tiene transiciones desde un mismo origen con el mismo
% caracter, pero que llegue a un destino distinto
% este predicado usa la tecnica generate (transcicionesDe) & test (noHayRepetidosDesdeOrigen)
esDeterministico(A) :- transicionesDe(A, T), noHayRepetidosDesdeOrigen(T).

% noHayRepetidosDesdeOrigen(+Transiciones)
% verifica que no haya dos transiciones que partan del mismo estado
% y utilicen la misma etiqueta
noHayRepetidosDesdeOrigen([]).
noHayRepetidosDesdeOrigen([T|Ts]) :- 
    esUnico(T, Ts), 
    noHayRepetidosDesdeOrigen(Ts).

% esUnico(+Transicion, +Transiciones)
esUnico(_, []).
esUnico((O, E, D), [(O2, E2, _)|Ts]) :- 
    not(sonIguales((O, E),(O2, E2))),
    esUnico((O, E, D), Ts).

% sonIguales(+T1, +T2)
sonIguales((A, B), (A, B)).

% 2) estados(+Automata, ?Estados)
% Dependiendo de si E esta o no instanciado, vamos a separar los casos
% En caso de E estar instanciado se verifica que los estados (distintos) de la lista recibida se correspondan
% con los del automata
estados(A, E) :- 
    nonvar(E),
    setof(X, member(X, E), Q),
    estados(A, R),
    conjuntosIguales(Q, R).

% En caso de no estarlo se instancian los estados que aparecen en las transiciones
% usando el predicado auxiliar listaDeEstados y luego se convierte la lista en set para
% eliminar repetidos
estados(a(I, F, T), E) :- 
    var(E),
    listaDeEstados(T, L),
    append([I|F], L, Q),
    setof(X, member(X, Q), E).

% listaDeEstados(+Transiciones, -Lista)
listaDeEstados([], []).
listaDeEstados([(O, _, D)|TS], [O, D|Q]) :- listaDeEstados(TS, Q).

% conjuntosIguales(+C1, +C2)
conjuntosIguales(X, Y) :- subtract(X, Y, []), subtract(Y, X, []).

% 3) esCamino(+Automata, ?EstadoInicial, ?EstadoFinal, +Camino)
% Un camino desde un estado final a uno inicial existe si hay una serie de transiciones
% a traves del alfabeto y estados del automata que nos permita armar este camino.
% usamos cut para evitar volver a usar la misma transicion luego de explorar una rama del
% arbol de backtracking.
esCamino(_, I, I, []).
esCamino(A, I, F, [C|CS]) :-
    hayTransicion(A, I, C),
    !,
    esCamino(A, C, F, CS).

% hayTransicion(+Automata, ?EstadoInicial, +EstadoFinal)
hayTransicion(_, I, I).
hayTransicion(a(_, _, T), EI, EF) :- member((EI, _, EF), T).

% 4) ¿el predicado anterior es o no reversible con respecto a Camino y por qué?
% No, pe

% 5) caminoDeLongitud(+Automata, +N, -Camino, -Etiquetas, ?S1, ?S2)
% El caso base esta dado cuando se pide el camino de longitud 1 y es valido
% cuando el estado de partida y el de llegada coinciden
% En otro caso, la longitud del camino debe ser mayor a 1 y
% probamos para cada transicion posible desde el estado de salida
% si se obtiene un camino hasta el estado de llegada
caminoDeLongitud(A, 1, [S], [], S, S) :- estados(A, E), member(S, E).
caminoDeLongitud(A, N, [S1|C], [E1|E], S1, S2) :- 
    N > 1,
    transicionDesde(A, S1, (S1, E1, TD)), 
    W is N-1, 
    caminoDeLongitud(A, W, C, E, TD, S2).

% transicionDesde(+Automata, ?Estado, ?Transicion)
% Si T esta instanciado, verifica si es una transicion posible en A desde el estado S
% sino, lo instancia con una posible transicion.
transicionDesde(a(_, _, TS), S1, (S1, E1, TD)) :- member((S1, E1, TD), TS).

% 6) alcanzable(+Automata, +Estado)
% Si el estado es inicial tiene exito,
% en caso contrario, verifica si E es alcanzable desde el estado inicial
% usamos el predicado cut para no continuar verificando luego de obtener una respuesta positiva
alcanzable(A, E) :- (inicialDe(A, E) ; inicialDe(A, I), alcanzableDesde(A, E, I)), !.

% alcanzableDesde(+Automata, +Estado, +EstadoDesde)
% Verificamos si hay un camino usando el predicado definido en el item anterior
% Para evitar un loop infinito en caso de que el automata tenga ciclos, 
% verificamos caminos que tengan a lo sumo una longitud igual a la cantidad de estados del
% automata (que es la maxima longitud posible para un camino sin ciclos)
alcanzableDesde(A, E, D) :- 
    estados(A, Es), 
    length(Es, N), 
    N2 is N + 1,
	between(2, N2, M), 
    caminoDeLongitud(A, M, _, _, D, E), 
    !.

% 7) automataValido(+Automata)
% definimos un predicado auxiliar para cada requisito, el predicado automataValido
% tiene exito si lo tienen cada uno de los auxiliares
automataValido(A) :- 
    todosTienenTransicionesSalientes(A),
    todosAlcanzablesDesdeElInicial(A),
    tieneAlMenosUnEstadoFinal(A),
    noHayFinalesRepetidos(A),
    noHayTransicionesRepetidas(A).

% todosTienenTransicionesSalientes(+Automata)
todosTienenTransicionesSalientes(A) :-
    estados(A, Es), 
    finalesDe(A, Fs),
    transicionesDe(A, T),
    forall(
        member(E, Es),
        (member(E, Fs) ; member((E, _, _), T))
    ).

% todosAlcanzablesDesdeElInicial(+Automata)
todosAlcanzablesDesdeElInicial(A) :-
    estados(A, Es),
    forall(
        member(E, Es),
        alcanzable(A, E)
    ).

% tieneAlMenosUnEstadoFinal(+Automata)
tieneAlMenosUnEstadoFinal(A) :-
    finalesDe(A, Fs),
    length(Fs, N),
    N > 0.

% noHayFinalesRepetidos(+Automata)
noHayFinalesRepetidos(A) :-
    finalesDe(A, Fs),
    esConjunto(Fs).

% noHayTransicionesRepetidas(+Automata)
noHayTransicionesRepetidas(A) :-
    transicionesDe(A, Ts),
    esConjunto(Ts).

% esConjunto(+Lista)
esConjunto([]).
esConjunto(C) :-
    setof(X, member(X, C), S),
    length(C, N),
    length(S, N).

%--- NOTA: De acá en adelante se asume que los autómatas son válidos.

% 8) hayCiclo(+Automata)
% un automata tiene ciclos si un estado es alcanzable desde si mismo
hayCiclo(A) :- 
    estados(A,Es),
    member(E, Es),
    alcanzableDesde(A, E, E).

% 9) reconoce(+Automata, ?Palabra)
% caso sin ciclos: Verificamos si existe un camino de longitud a lo sumo #estados del automata
% entre el estado inicial y cada estado final y tal que sus etiquetas coincidan con P en caso
% de estar instanciada, o que retorne cada posible lista de etiquetas en caso de no estarlo
reconoce(A, P) :- 
	not(hayCiclo(A)), 
	inicialDe(A, In), 
	finalesDe(A, Fs),
	estados(A, Es), 
	length(Es, N),
    between(1, N, M), 
	member(F, Fs),
    caminoDeLongitud(A, M, _, P, In, F).

% caso con ciclos: Analogo al caso sin ciclos pero, para evitar entrar en un loop infinito, verificamos 
% solamente caminos cuya longitud coincida con la de la palabra en caso de estar instanciada, 
% o retorne palabras validas de longitud incremental en caso de no estarlo.
reconoce(A, P) :- 
	hayCiclo(A),
    inicialDe(A, In),
	finalesDe(A, Fs), 
	member(F, Fs),
	length(P, N),
	M is N + 1,
    caminoDeLongitud(A, M, _, P, In, F).

% 10) palabraMásCorta(+Automata, ?Palabra)
% Primero obtenemos la longitud de la palabra mas corta usando el predicado
% reconoce definido anteriormente, y luego construimos las palabras de dicha longitud
% usando el predicado caminoDeLongitud, que instancia las etiquetas en la variable P o
% devuelve true en caso de que P este instanciada y sea un camino valido.
palabraMasCorta(A, P) :- 
	inicialDe(A, In), 
	finalesDe(A, Fs),
    member(F, Fs),
	longitudPalabraMasCorta(A, N), 
	N2 is N + 1, 
	caminoDeLongitud(A, N2, _, P, In, F).

% longitudPalabraMasCorta(+Automata, -Longitud)
% usamos el metapredicado cut porque reconoce instancia palabras de longitud incremental
% por lo que el primer resultado sera la palabra mas corta, no es necesario
% seguir evaluando.
longitudPalabraMasCorta(A, N) :-
	reconoce(A, P),
    length(P, N),
    !.

% ----- Tests -----
test(1) :- forall(ejemplo(_, A),  automataValido(A)).
test(2) :- not((ejemploMalo(_, A),  automataValido(A))).
test(3) :- ejemplo(10, A), reconoce(A, [p, X, r, X, d, i, _, m, X, s]).
test(4) :- ejemplo(9, A), reconoce(A, [a,  b,  a,  b,  a,  b,  a,  b]).
test(5) :- ejemplo(7, A), reconoce(A, [a,  a,  a,  b,  b]).
test(6) :- ejemplo(7, A), not(reconoce(A, [b])).
test(7) :- ejemplo(2, A),  findall(P, palabraMasCorta(A, P), [[]]).
test(8) :- ejemplo(4, A),  findall(P, palabraMasCorta(A, P), Lista), length(Lista, 2), sort(Lista, [[a], [b]]).
test(9) :- ejemplo(5, A),  findall(P, palabraMasCorta(A, P), Lista), length(Lista, 2), sort(Lista, [[b], [c]]).
test(10) :- ejemplo(6, A),  findall(P, palabraMasCorta(A, P), [[b, a]]).
test(11) :- ejemplo(7, A),  findall(P, palabraMasCorta(A, P), [[a, b]]).
test(12) :- ejemplo(8, A),  findall(P, palabraMasCorta(A, P), Lista), length(Lista, 2), sort(Lista, [[a,  a,  b,  f], [a,  b,  b,  f]]).
test(13) :- ejemplo(10, A),  findall(P, palabraMasCorta(A, P), [[p, r, o, l, o, g]]).
test(14) :- forall(member(X, [2, 4, 5, 6, 7, 8, 9]), (ejemplo(X, A), hayCiclo(A))).
test(15) :- not((member(X, [1, 3, 10]), ejemplo(X, A), hayCiclo(A))).
test(16) :- ejemplo(1, A), esDeterministico(A).
test(17) :- ejemplo(8, A), not(esDeterministico(A)).
test(18) :- ejemplo(1, A), estados(A, [s1, sf]).
test(19) :- ejemplo(1, A), estados(A, E), E = [s1, sf].
test(20) :- ejemplo(4, A), esCamino(A, s1, s2, [s1, s2]).
test(21) :- ejemplo(4, A), esCamino(A, X, Y, [s1, s2]), X = s1, Y = s2.
test(22) :- ejemplo(4, A), caminoDeLongitud(A, 2, C, E, s1, s2), C = [s1, s2], E = [a].
test(23) :- ejemplo(4, A), caminoDeLongitud(A, 2, C, E, X, Y), C = [s1, s2], E = [a], X = s1, Y = s2.
test(24) :- ejemplo(7, A), alcanzable(A, s3).
test(25) :- ejemplo(7, A), not(alcanzable(A, s20)).
tests :- forall(between(1, 25, N), test(N)).