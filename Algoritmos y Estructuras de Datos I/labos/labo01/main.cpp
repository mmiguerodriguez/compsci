#include <iostream>
#include <fstream>

using namespace std;

bool esPrimo(int n) {
    if (n <= 1) return false;

    for (int i = 2; i < n; i++) {
        if (n % i == 0) {
            return false;
        }
    }

    return true;
}

void ejercicio11() {
    cout << "Ingrese un numero: ";
    int n = 0;
    cin >> n;

    if (esPrimo(n)) {
        cout << "El numero ingresado es primo" << endl;
    } else {
        cout << "El numero ingresado no es primo" << endl;
    }
}

void escribirArchivo() {
    int a = 1;
    int b = 2;
    float f = 3.7;
    float g = 8.5;

    ofstream fout;
    fout.open("salida.txt");
    fout << a << "," << b << "," << f << "," << g << endl;
    fout.close();
}

void ejercicio13() {
    int a;
    float b;

    ifstream fin;
    fin.open("entrada.txt");
    fin >> a;
    fin >> b;
    fin.close();

    cout << a << " " << b << endl;
}

void ejercicio14() {
    int n;
    ifstream fin;
    fin.open("numeros.txt");

    if (!fin.fail()) {
        while (!fin.eof()) {
            fin >> n;
            cout << n << " ";
        }
    }

    fin.close();
}

void  prueba(int& x, int& y) {
    x = x + y;
    y = x - y;
    x = 1/y;
}

void swap(int& a, int& b) {
    int _a = a;
    int _b = b;

    a = _b;
    b = _a;
}

void divisionIterativa(int dividendo, int divisor, int& cociente, int& resto) {
    cociente = 0;
    resto = 0;

    while (dividendo >= divisor) {
        cociente += 1;
        dividendo -= divisor;
    }

    resto = dividendo;
}

void divisionRecursiva(int dividendo, int divisor, int& cociente, int& resto) {
    cociente = 0;
    resto = 0;

    if (dividendo >= divisor) {
        cociente += 1;
        divisionRecursiva(dividendo - divisor, divisor, cociente, resto);
    } else {
        resto = dividendo;
    }
}

void collatzRecursivo(int n, int& cantPasos) {
    if (cantPasos == 0) {
        cout << n << " ";
    }

    cantPasos += 1;

    if (n == 1) {
        cout << endl << "Cantidad de pasos: " << cantPasos << endl;
    } else if (n % 2 == 0) {
        n /= 2;
        cout << n << " ";
        collatzRecursivo(n, cantPasos);
    } else {
        n = n * 3 + 1;
        cout << n << " ";
        collatzRecursivo(n, cantPasos);
    }
}

void collatzIterativo(int n, int& cantPasos) {
    cout << n << " ";

    while (n != 1) {
        if (n % 2 == 0) {
            n /= 2;
        } else {
            n = n * 3 + 1;
        }

        cout << n << " ";
        cantPasos += 1;
    }

    cantPasos += 1; // cuenta como un paso cuando n = 1
    cout << endl << "Cantidad de pasos: " << cantPasos << endl;
}

void ejercicio19() {
    int a;
    int b;

    ifstream numeros;
    ifstream numeros1;
    numeros.open("numeros.txt");
    numeros1.open("numeros1.txt");

    if (!numeros.fail() && !numeros1.fail()) {

        ofstream suma;
        suma.open("suma.txt");

        while (!numeros.eof() && !numeros1.eof()) {
            numeros >> a;
            numeros1 >> b;

            suma << (a + b) << " ";
        }

        suma.close();
    }

    numeros.close();
    numeros1.close();
}

void primosGemelos(int n, int& res1, int& res2) {
    int i = 0;
    res1 = 0;
    res2 = 0;

    ofstream fout;
    fout.open("primosgemelos.txt");

    while(n != i) {
        res1++;
        res2 = res1 + 2;

        if (esPrimo(res1) && esPrimo(res2)) {
            fout << "(" << res1 << "," << res2 << ")" << " ";
            i++;
        }
    }

    fout.close();
}

int main() {
    ejercicio11();
    escribirArchivo();
    ejercicio13();
    ejercicio14();

    int pruebaN = 10;
    // prueba(pruebaN, pruebaN); // esto se rompe

    int a = 10;
    int b = 15;
    swap(a, b);

    int cantPasos = 0;
    int cantPasos2 = 0;
    int collatzN = 11;
    collatzRecursivo(collatzN, cantPasos);
    collatzIterativo(collatzN, cantPasos2);

    ejercicio19();

    int dividendo = 178;
    int divisor = 9;
    int cociente = 0;
    int resto = 0;
    int cociente2 = 0;
    int resto2 = 0;

    divisionIterativa(dividendo, divisor, cociente, resto);
    divisionRecursiva(dividendo, divisor, cociente2, resto2);

    int res1 = 0;
    int res2 = 0;
    primosGemelos(7, res1, res2);

    return 0;
}