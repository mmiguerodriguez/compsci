from unittest import skip
from calclex import tokens

import ply.yacc as yacc
import json
import string
import random
import sys

# Tipos de datos reservados + generacion de datos aleatoria
reserved_types = ['struct', 'bool', 'float64', 'string', 'int']

def randomDataValue(aDataType):
    if aDataType == 'string':
        return randomString()
    elif aDataType == 'int':
        return randomInt()
    elif aDataType == 'bool':
        return randomBool()
    elif aDataType == 'float64':
        return randomFloat()
    else:
        return aDataType

def randomString():
    letters = string.ascii_lowercase
    res = ''.join(random.choice(letters) for _ in range(5))
    return "\"" + res + "\""

def randomInt():
    return str(random.randint(0, 1000))

def randomFloat():
    return str(round(random.uniform(0, 1000), 3))

def randomBool():
    values = ['true', 'false']
    return values[random.randint(0, 1)]

def tab(aTabsNumberAmount):
    return aTabsNumberAmount * '  '

# Clases que representan las estructuras de datos de la gramatica

# MainStructure contiene a la estructura principal a printear
# junto con las sub-estructuras posibles que puede utilizar
class MainStructure():
    def __init__(self, structure, other_structures):
        self.structure = structure
        self.other_structures = other_structures

    def show(self):
        tabs = 0
        structures = self.other_structures + [self]
        result = self.structure.show(structures, tabs)
        return result

    def adjacents(self):
        adjacency_dict = {}
        adjacency_dict[self.structure.name] = self.structure.adjacents()

        for struct in self.other_structures:
            adjacency_dict[struct.structure.name] = struct.structure.adjacents()

        return adjacency_dict

# Representacion de sub-estructura
class OtherStructure():
    def __init__(self, structure):
        self.structure = structure

    def show(self, other_structures, tabs):
        result = "{\n"

        for variable in self.structure.variables:
            result += variable.show(other_structures, tabs + 1) 
            result += "\n"

        result += tab(tabs) + "}"

        return result

# Estructura con nombre y variables
class Struct():
    def __init__(self, name, variables):
        self.name = name
        self.variables = variables

    def show(self, other_structures, tabs):
        result = ""

        if tabs != 0:
            result = tab(tabs) + "\"" + self.name + "\": {\n"
        else:
            result = "{\n"

        for variable in self.variables:
            result += variable.show(other_structures, tabs + 1)
            result += "\n"

        result += tab(tabs) + "}"

        return result

    def adjacents(self):
        adjacent_list = []

        for variable in self.variables:
            if isinstance(variable, Struct):
                adjacent_list = adjacent_list + variable.adjacents()
            else:
                if variable.datatype.name not in reserved_types:
                    adjacent_list.append(variable.datatype.name)

        return adjacent_list

# Variable con nombre y tipo de dato (su tipo podria ser Struct)
class Variable():
    def __init__(self, name, datatype):
        self.name = name
        self.datatype = datatype

    def show(self, other_structures, tabs):
        return tab(tabs) + "\"" + self.name + "\": " + self.datatype.show(other_structures, tabs) + ","

# Tipo de dato con su nombre (podria ser de los reservados como no serlo)
class DataType():
    def __init__(self, name):
        self.name = name

    def show(self, other_structures, tabs):
        if self.name not in reserved_types:
            struct = self.findStructure(self.name, other_structures)
            return struct.show(other_structures, tabs)
            
        return randomDataValue(self.name)

    def findStructure(self, name, other_structures):
        result = None
        for struct in other_structures:
            if struct.structure.name == name:
                result = struct
        
        if isinstance(result, MainStructure):
            sys.exit("ERROR: Se han detectado ciclos.")
        elif result == None:
            sys.exit("ERROR: La estructura \"" + name + "\" no fue encontrada.")

        return result

# Clase para representar listas
class ListType():
    def __init__(self, datatype):
        self.name = datatype.name
        self.of = datatype

    def show(self, other_structures, tabs):
        result = "[\n"

        for i in range(5):
            result += tab(tabs + 1) + self.of.show(other_structures, tabs + 1) + ("," if i != 4 else "")
            result += "\n"

        result += tab(tabs) + "]"

        return result

def p_expression(p):
    '''
      expression : TYPE data expression_inner
    '''
    p[0] = MainStructure(p[2], p[3])

def p_expression_inner(p):
    '''
      expression_inner : TYPE data expression_inner
                       | empty_expression
    '''
    if len(p) == 2:
        p[0] = p[1]
    else:
        p[0] = [OtherStructure(p[2])] + p[3]

def p_expression_data(p):
    'data : ID STRUCT obj'
    p[0] = Struct(p[1], p[3])

def p_expression_obj(p):
    'obj : OPENBRACE variables CLOSEBRACE'
    p[0] = p[2]

def p_expression_variables(p):
    '''
      variables : ID datatype variables
                | data
                | empty_variable
    '''
    if len(p) == 2:
        p[0] = p[1]
    else:
        if type(p[3]) is not list: # Fix casos en los que p[3] = None... 
            p[0] = [Variable(p[1], p[2])] + [p[3]]
        else:
            p[0] = [Variable(p[1], p[2])] + p[3]

def p_expression_datatype(p):
    '''
      datatype : STRING
               | BOOL
               | INT
               | FLOAT64
               | ID
               | LIST datatype
    '''
    if len(p) == 2:
        p[0] = DataType(p[1])
    else:
        p[0] = ListType(p[2])

def p_empty_variable(p):
    'empty_variable :'
    p[0] = []

def p_empty_expression(p):
    'empty_expression :'
    p[0] = []

def p_error(p):
    sys.exit("ERROR: No se ha podido construir el objeto correctamente. Linea: " + str(p.lineno))

def hasCycles(dict):
    def DFS(node):
        # Cycle detected.
        if visited[node] == 1:
            return False
        
        # Visit this node, explore neighbors.
        visited[node] = 1
        for nbr in dict[node]:
            if visited[nbr] != 2 and not DFS(nbr):
                return False
        
        # Done visiting node.
        visited[node] = 2
        return True

    visited = {}

    for e in dict.keys():
        visited[e] = 0

    if not DFS(result_object.structure.name):
        return True

    return False

# Build the parser
parser = yacc.yacc()

# Output result (or errors)
with open('input.in') as input_file:
    data = input_file.read()
    result_object = parser.parse(data)
    result_string = result_object.show()

    adjacents_dict = result_object.adjacents()
    if hasCycles(adjacents_dict):
        sys.exit("ERROR: Se han detectado ciclos.")

    result_string = result_object.show()
    with open('output.out', 'w') as output_file:
        output_file.write(result_string)

sys.exit()