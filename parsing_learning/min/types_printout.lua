a=[[
GLOBAL_ASSIGNMENT
    IDENTIFIER(def)
    ASSIGN(=)
    OPERATORCHAIN
        ORCHAIN
            ANDCHAIN
                STRING("abc")
                AND(and)
                STRING("def")
            OR(or)
            ANDCHAIN
                NUMBER(12333)
                AND(and)
                NUMBER(123123)
            OR(or)
            ANDCHAIN
                NUMBER(22)
                AND(and)
                VALUECHAIN
                    NUMBER(123123)
                    BINARY_OP(+)
                    PARENTHESIS
                        OPENBRACKET(()
                        OPERATORCHAIN
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(a)
                                AND(and)
                                EXPCHAIN
                                    IDENTIFIER(b)
                                AND(and)
                                EXPCHAIN
                                    IDENTIFIER(c)
                        CLOSEBRACKET())
EOF
]]