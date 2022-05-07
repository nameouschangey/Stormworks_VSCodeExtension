a=[[
GLOBAL_ASSIGNMENT
    IDENTIFIER(def)
    ASSIGN(=)
        WHITESPACE( )
    OPERATORCHAIN
        ORCHAIN
            ANDCHAIN
                STRING("abc")
                    WHITESPACE( )
                AND(and)
                    WHITESPACE( )
                STRING("def")
                    WHITESPACE( )
            OR(or)
                WHITESPACE( )
            ANDCHAIN
                NUMBER(12333)
                    WHITESPACE( )
                AND(and)
                    WHITESPACE( )
                NUMBER(123123)
                    WHITESPACE( )
            OR(or)
                WHITESPACE( )
            ANDCHAIN
                NUMBER(22)
                    WHITESPACE( )
                AND(and)
                    WHITESPACE( )
                VALUECHAIN
                    NUMBER(123123)
                        WHITESPACE( )
                    BINARY_OP(+)
                        WHITESPACE( )
                    PARENTHESIS
                        OPENBRACKET(()
                            WHITESPACE( )
                        OPERATORCHAIN
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(a)
                                AND(and)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(b)
                                        WHITESPACE( )
                                AND(and)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(c)
                                        WHITESPACE( )
                        CLOSEBRACKET())
EOF
    WHITESPACE(\n)
]]