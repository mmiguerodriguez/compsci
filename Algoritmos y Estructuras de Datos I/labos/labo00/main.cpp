#include  <iostream>
int f(int x){
    return x+1;
}

int g(int x, int y){
    return x+y;
}

int h(int x, int y) {
    if (x > y) return x+y;
    else return x*y;
}

bool esPrimo(int x) {
    for (int i = 2; i < x; i++) {
        if (x % i == 0) return false;
    }

    return true;
}

int fibonacci(int n) {
    if (n == 0) return 0;
    if (n == 1) return 1;

    return fibonacci(n-1) + fibonacci(n-2);
}

int fibonacci2(int n) {
    if (n == 0) return 0;
    if (n == 1) return 1;

    int l1 = 0;
    int l2 = 1;
    int result = 0;

    for (int i = 2; i <= n; i++) {
        result = l1 + l2;
        l1 = l2;
        l2 = result;
    }

    return result;
}

int fibonacci3(int n) {
    if (n == 0) return 0;
    if (n == 1) return 1;

    int l1 = 0;
    int l2 = 1;
    int result = 0;

    int i = 2;
    while (i <= n) {
        result = l1 + l2;
        l1 = l2;
        l2 = result;

        i++;
    }

    return result;
}

int sumaImpares(int n) {
    int i = 1;
    int r = 0;

    while (i < n) {
        if (i % 2 != 0) r += i;
        i += 1;
    }

    return r;
}

int sumaImpares2(int n) {
    int r = 0;

    for(int i = 1; i < n; i++) {
        if (i % 2 != 0) r += i;
    }

    return r;
}

int sumaImpares3(int n) {
    if (n == 0) return 0;

    if (n % 2 != 0) return n + sumaImpares3(n-1);
    else return sumaImpares3(n-1);
}

int sumaDivisores(int n) {
    int s = 0;

    for (int i = 1; i <= n; i++) {
        if (n % i == 0) {
            s += i;
        }
    }

    return s;
}

int sumaDivisores2(int n) {
    int i = 1;
    int s = 0;

    while (i <= n) {
        if (n % i == 0) {
            s += i;
        }
        i++;
    }

    return s;
}

int sumaDivisoresHasta(int i, int n) {
    if (i == 1) return 1;

    if (n % i == 0) return i + sumaDivisoresHasta(i-1, n);
    else return sumaDivisoresHasta(i-1, n);
}

int sumaDivisores3(int n) {
    return sumaDivisoresHasta(n, n);
}

int combinatorio(int n, int k) {
    if (n == k) return 1;
    if (k == 0) return 1;
    if (k == 1) return n;

    return combinatorio(n-1, k) + combinatorio(n-1, k-1);
}


int combinatorio2(int n, int k) {
    return 1;
}

int  main() {
    std::cout << "1: " << f(10)  << std::endl;
    std::cout << "2: " << g(10,11)  << std::endl;
    std::cout << "3: " << h(10,11)  << std::endl;
    std::cout << "4: " << esPrimo(11)  << std::endl;
    std::cout << "5: Crear un proyecto nuevo de C++ en CLion" << std::endl;
    std::cout << "6: " << fibonacci(11) << " " << fibonacci2(11) << " " << fibonacci3(11) << std::endl;
    std::cout << "7: " << sumaImpares(10) << " " << sumaImpares2(10) << " " << sumaImpares3(10) << std::endl;
    std::cout << "8: " << sumaDivisores(12) << " " << sumaDivisores2(12) << " " << sumaDivisores3(12) << std::endl;
    std::cout << "9: " << combinatorio(15, 7) << std::endl;
    return  0;
}
