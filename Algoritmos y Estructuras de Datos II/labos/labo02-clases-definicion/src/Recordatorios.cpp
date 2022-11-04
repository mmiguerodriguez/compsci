#include <iostream>
#include <list>

using namespace std;

// Pre: 0 <= mes < 12
uint dias_en_mes(uint mes) {
    uint dias[] = {
        // ene, feb, mar, abr, may, jun
        31, 28, 31, 30, 31, 30,
        // jul, ago, sep, oct, nov, dic
        31, 31, 30, 31, 30, 31
    };
    return dias[mes - 1];
}

// Ejercicio 7, 8, 9 y 10

// Clase Fecha
class Fecha {
  public:
    Fecha(int mes, int dia);
    int mes();
    int dia();
    #if EJ >= 9 // Para ejercicio 9
    bool operator==(Fecha o);
    #endif
    void incrementar_dia();

  private:
    int mes_;
    int dia_;
};

Fecha::Fecha(int mes, int dia): dia_(dia), mes_(mes) {}

int Fecha::mes() {
    return mes_;
}

int Fecha::dia() {
    return dia_;
}

void Fecha::incrementar_dia() {
    if (dias_en_mes(mes_) == dia_) {
        if (mes_ == 12) {
            mes_ = 1;
        } else {
            mes_ += 1;
        }
        dia_ = 1;
    } else {
        dia_ += 1;
    }
}

ostream& operator<<(ostream& os, Fecha f) {
    os << f.dia() << "/" << f.mes();
    return os;
}

#if EJ >= 9
bool Fecha::operator==(Fecha f) {
    return dia_ == f.dia() && mes_ == f.mes();
}
#endif

// Ejercicio 11, 12

// Clase Horario

class Horario {
public:
    Horario(uint hora, uint min);
    uint hora();
    uint min();
    bool operator==(Horario h);
    bool operator<(Horario h);
private:
    uint hora_;
    uint min_;
};

Horario::Horario(uint hora, uint min): hora_(hora), min_(min) {}

uint Horario::hora() {
    return hora_;
}

uint Horario::min() {
    return min_;
}

ostream& operator<<(ostream& os, Horario h) {
    os << h.hora() << ":" << h.min();
    return os;
}

bool Horario::operator==(Horario h) {
    return hora_ == h.hora() && min_ == h.min();
}

bool Horario::operator<(Horario h) {
    if (hora_ == h.hora()) {
        return min_ < h.min();
    } else {
        return hora_ < h.hora();
    }
}

// Ejercicio 13

// Clase Recordatorio
class Recordatorio {
public:
    Recordatorio(Fecha f, Horario h, string m);
    string mensaje();
    Fecha fecha();
    Horario horario();
private:
    string mensaje_;
    Fecha fecha_;
    Horario horario_;
};

Recordatorio::Recordatorio(Fecha f, Horario h, string m): mensaje_(m), fecha_(f), horario_(h) {}

string Recordatorio::mensaje() {
    return mensaje_;
}

Fecha Recordatorio::fecha() {
    return fecha_;
}

Horario Recordatorio::horario() {
    return horario_;
}

ostream& operator<<(ostream& os, Recordatorio r) {
    os << r.mensaje() << " @ " << r.fecha() << " " << r.horario();
    return os;
}

// Ejercicio 14

// Clase Agenda

class Agenda {
public:
    Agenda(Fecha fecha_inicial);
    void agregar_recordatorio(Recordatorio rec);
    void incrementar_dia();
    list<Recordatorio> recordatorios_de_hoy();
    Fecha hoy();
private:
    Fecha dia_actual_;
    list<Recordatorio> recordatorios_;
};

Agenda::Agenda(Fecha fecha_inicial): dia_actual_(fecha_inicial) {}

void Agenda::agregar_recordatorio(Recordatorio rec) {
    list<Recordatorio>::iterator it;
    bool inserte = false;

    // Agrego los recordatorios segun el horario en la lista de recordatorios.
    // No es lo mas lindo que seria agregarlo segun la fecha y luego segun el horario
    // pero para hacer mas simple el codigo decidi hacerlo de esta manera y en
    // recordatorios_de_hoy() iterar y preguntar si cada recordatorio es de la fecha de hoy

    // Intente hacer recordatorios_ como un map<Fecha, list<Recordatorio>> pero al intentar acceder
    // a un _recordatorio[Fecha] c++ tiraba un error raro sobre el operator< y comparaciones entre
    // fechas entonces decidi no hacerlo de esa forma.

    for (it = recordatorios_.begin(); it != recordatorios_.end() && !inserte; it++) {
        if (rec.horario() < it->horario()) {
            recordatorios_.insert(it, rec);
            inserte = true;
        }
    }

    if (!inserte) {
        recordatorios_.push_back(rec);
    }
}

void Agenda::incrementar_dia() {
    dia_actual_.incrementar_dia();
}

list<Recordatorio> Agenda::recordatorios_de_hoy() {
    list<Recordatorio> recordatoriosHoy;

    for (Recordatorio r : recordatorios_) {
        if (r.fecha() == dia_actual_) {
            recordatoriosHoy.push_back(r);
        }
    }

    return recordatoriosHoy;
}

Fecha Agenda::hoy() {
    return dia_actual_;
}

ostream& operator<<(ostream& os, Agenda a) {
    os << a.hoy() << endl;
    os << "=====" << endl;

    for (Recordatorio r : a.recordatorios_de_hoy()) {
        os << r << endl;
    }

    return os;
}
