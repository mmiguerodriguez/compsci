#include "SistemaDeMensajes.h"
// Completar...

SistemaDeMensajes::SistemaDeMensajes() : _conns() {

}

void SistemaDeMensajes::registrarJugador(int id, string ip) {
    if (registrado(id)) {
        desregistrarJugador(id);
    }

    ConexionJugador *j = new ConexionJugador(ip);
    _conns[id] = j;
}

bool SistemaDeMensajes::registrado(int id) const {
    return _conns[id];
}

void SistemaDeMensajes::enviarMensaje(int id, string mensaje) {
    if (registrado(id)) {
        _conns[id]->enviarMensaje(mensaje);
    }
}

string SistemaDeMensajes::ipJugador(int id) const {
    return _conns[id]->ip();
}

SistemaDeMensajes::~SistemaDeMensajes() {
    for (int i = 0; i < 4; i++) {
        delete _conns[i];
    }

    for (int i = 0; i < _proxies.size(); i++) {
        delete _proxies[i];
    }
}

void SistemaDeMensajes::desregistrarJugador(int id) {
    if (registrado(id)) {
        delete _conns[id];
        _conns[id] = NULL;
    }
}

SistemaDeMensajes::Proxy* SistemaDeMensajes::obtenerProxy(int id) {
    Proxy* p = new Proxy(&_conns[id]);
    _proxies.push_back(p);
    return p;
}

SistemaDeMensajes::Proxy::Proxy(ConexionJugador** conn) : _conn(conn) {}

void SistemaDeMensajes::Proxy::enviarMensaje(string msg) {
    (*_conn)->enviarMensaje(msg);
}
