#	Irina Marcano 13-10805
#	Fernando Gonzalez 08-10464 


class Parser

    #Procedemos a declarar los tokens de BasicTran

    token   ',' '.' ';' ':' '(' ')' '[' ']' '{' '}' '->' '<-'
            '+' '-' '*' '/' '%' '/\' '\/' 'not' '/=' '<' '<='
            '>' '>=' '=' '++' '--' '#' '::' '$' 'with' 'true' 
            'false' 'var' 'begin' 'end' 'int' 'while' 'if' 
            'else' 'bool' 'char' 'array' 'read' 'of' 'print' 
            'for' 'step' 'from' 'to' UMINUS
           
    #Declaramos la presedencia de los operadores donde el de mayor presedencia
    #se encuentra de primero en la tabla

    prechigh
        nonassoc    UMINUS
        left        '*' '/' '%'            
        left        '+' '-'   
        left        'not'   
        left        '/\'            
        left        '\/'   
        left        '#'   
        left        '--'   
        left        '++'   
        left        '[]'   
        left        '$'   
        left        '::'   
    preclow

    #Procedemos a indicar las equivalencia de los Tokens con los signos
    convert
        '.'         'TkPunto'
        'num'       'TkNum'
        'char'      'TkCaracter'
        'id'        'TkId'
        ','         'TkComa'
        ':'         'TkDosPuntos'
        '('         'TkParAbre'
        ')'         'TkParCierra'
        '['         'TkCorcheteAbre'
        ']'         'TkCorcheteCierra'
        '{'         'TkLlaveAbre'
        '}'         'TkLlaveCierra'
        '-'         'TkResta'
        '->'        'TkHacer'
        '<-'        'TkAsignacion'
        '+'         'TkSuma'
        '/='        'TkDesigual'
        ';'         'TkPuntoYComa'
        '*'         'TkMult'
        '/'         'TkDiv'
        '%'         'TkMod'
        '/\'        'TkConjuncion'
        '\/'        'TkDisyuncion'
        'not'       'TkNegacion'
        '<'         'TkMenor'
        '<='        'TkMenorIgual'
        '>'         'TkMayorIgual'
        '='         'Tkigual'
        '++'        'TkSiguienteCar'
        '--'        'TkAnteriorCar'
        '#'         'TkValorAscii'
        '::'        'TkConcatenacion'
        '$'         'TkShift'
        'with'      'Tkwith' 
        'true'      'Tktrue' 
        'false'     'Tkfalse' 
        'var'       'Tkvar' 
        'begin'     'Tkbegin' 
        'end'       'Tkend' 
        'int'       'Tkint' 
        'while'     'Tkwhile' 
        'if'        'Tkif' 
        'else'      'Tkelse' 
        'bool'      'Tkbool' 
        'char'      'Tkchar' 
        'array'     'Tkarray' 
        'read'      'Tkread' 
        'of'        'Tkof' 
        'print'     'Tkprint' 
        'for'       'Tkfor' 
        'step'      'Tkstep' 
        'from'      'Tkfrom' 
        'to'        'Tkto'
    end


#declarando la gramatica

rule

    Instruccion:    'id' '<-' Expresion                                                 {  result = Asignacion::new(val[0], val[2])              } 
                |   'begin' Declaraciones Instrucciones 'end'                           {  result = Bloque::new(val[1], val[2])                  }
                |   'read' 'id'                                                         {  result = Read::new(val[1])                            }
                |   'print' ElementoSalida                                              {  result = Print::new(val[1])                           }
                |   'if' Expresion 'else' Instruccion                                   { result = Condicional_Else::new(val[1], val[3])         }
                |   'for' 'id' 'from' Expresion 'to' Expresion '->' Instruccion         { result = Iteracion_Det::new(val[1], val[3], val[5])    }
                |   'while' Expresion '->' Instruccion                                  { result = Iteracion_Indet::new(val[1], val[3])          }
                ;
    
      Expresion:    'num'                                                               { result = Entero::new(val[0])                           }
               |    'true'                                                              { result = True::new()                                   }
               |    'false'                                                             { result = False::new()                                  }
               |    'id'                                                                { result = Variable::new(val[0])                         }
               |    Expresion '%'   Expresion                                           { result = Modulo::new(val[0], val[2])                   }
               |    Expresion '*'   Expresion                                           { result = Multiplicacion::new(val[0], val[2])           }
               |    Expresion '+'   Expresion                                           { result = Suma::new(val[0], val[2])                     }
               |    Expresion '-'   Expresion                                           { result = Resta::new(val[0], val[2])                    }
               |    Expresion '/'   Expresion                                           { result = Division::new(val[0], val[2])                 }
               |    Expresion '/='  Expresion                                           { result = Desigual::new(val[0], val[2])                 }
               |    Expresion '<'   Expresion                                           { result = Menor_Que::new(val[0], val[2])                }
               |    Expresion '<='  Expresion                                           { result = Menor_Igual_Que::new(val[0], val[2])          }
               |    Expresion '='   Expresion                                           { result = Igual::new(val[0], val[2])                    }
               |    Expresion '>'   Expresion                                           { result = Mayor_Que::new(val[0], val[2])                }
               |    Expresion '>='  Expresion                                           { result = Mayor_Igual_Que::new(val[0], val[2])          }
               |    Expresion '/\'  Expresion                                           { result = And::new(val[0], val[2])                      }
               |    Expresion '\/'  Expresion                                           { result = Or::new(val[0], val[2])                       }
               |    'not' Expresion                                                     { result = Not::new(val[1])                              }
               |    '-'   Expresion = UMINUS                                            { result = Menos_Unario::new(val[1])                     }
               |    '(' Expresion ')'                                                   { result = val[1]                                        }
               ;