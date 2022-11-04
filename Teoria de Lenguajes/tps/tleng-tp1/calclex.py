import ply.lex as lex
import sys

reserved = {
    'type': 'TYPE',
    'struct': 'STRUCT',
    'bool': 'BOOL',
    'float64': 'FLOAT64',
    'string': 'STRING',
    'int': 'INT',
}

tokens = [
    'ID',
    'OPENBRACE',
    'CLOSEBRACE',
    'LIST'
] + list(reserved.values())

# Regex for tokens
t_OPENBRACE = r'\{'
t_CLOSEBRACE = r'\}'
t_LIST = r'\[\]'

def t_ID(t):
    r'[a-z][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value, 'ID')
    return t

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)


# A string containing ignored characters (spaces and tabs)
t_ignore = ' \t'

# Error handling rule
def t_error(t):
    sys.exit("ERROR: Caracter invalido \"" + t.value[0] + "\". Linea: " +  str(t.lineno))

# Build the lexer
lexer = lex.lex()
