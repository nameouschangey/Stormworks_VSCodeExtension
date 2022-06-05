a=[[
GLOBAL_NAMEDFUNCTIONDEF
    FUNCTION(function)
        WHITESPACE(\n)
    IDENTIFIER(abc)
        WHITESPACE( )
    FUNCTIONDEF_PARAMS
        OPENBRACKET(()
        CLOSEBRACKET())
    RETURNSTATEMENT
        RETURN(return)
            WHITESPACE(\n\n    )
        NUMBER(123)
            WHITESPACE( )
        COMMA(,)
        NUMCHAIN
            NUMBER(12)
                WHITESPACE( )
            MATHOP(+)
            NUMBER(24)
    END(end)
        WHITESPACE(\n)
GLOBAL_ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(a)
            WHITESPACE(\n\n)
    ASSIGN(=)
        WHITESPACE( )
    TABLEDEF
        OPENCURLY({)
            WHITESPACE( )
        NUMBER(1)
        CLOSECURLY(})
EXPCHAIN
    IDENTIFIER(table)
        WHITESPACE(\n)
    DOTACCESS(.)
    IDENTIFIER(insert)
    FUNCTIONCALL
        OPENBRACKET(()
        EXPCHAIN
            IDENTIFIER(a)
        COMMA(,)
        NUMBER(3)
            WHITESPACE( )
        COMMA(,)
        NUMBER(2)
            WHITESPACE( )
        CLOSEBRACKET())
IF_STATEMENT
    IF(if)
        WHITESPACE(\n\n)
    BOOLCHAIN
        EXPCHAIN
            IDENTIFIER(a)
                WHITESPACE( )
        BOOLOP(==)
        NUMBER(123)
    THEN(then)
        WHITESPACE( )
    EXPCHAIN
        IDENTIFIER(a)
            WHITESPACE(\n    )
        COLONACCESS(:)
        IDENTIFIER(doStuff)
        FUNCTIONCALL
            OPENBRACKET(()
            CLOSEBRACKET())
    ELSE(else)
        WHITESPACE(\n)
    EXPCHAIN
        IDENTIFIER(doSomething)
            WHITESPACE(\n    )
        FUNCTIONCALL
            OPENBRACKET(()
            CLOSEBRACKET())
    FOR_LOOP
        FOR(for)
            WHITESPACE(\n    )
        IDENTIFIER(i)
            WHITESPACE( )
        ASSIGN(=)
        NUMBER(1)
        COMMA(,)
        NUMBER(123)
            WHITESPACE( )
        DO(do)
            WHITESPACE( )
        LOCAL_ASSIGNMENT
            LOCAL(local)
                WHITESPACE(\n        )
            IDENTIFIER(alc)
                WHITESPACE( )
            ASSIGN(=)
                WHITESPACE( )
            NUMCHAIN
                NUMBER(123)
                    WHITESPACE( )
                MATHOP(+)
                    WHITESPACE( )
                NUMBER(123)
                    WHITESPACE( )
        END(end)
            WHITESPACE(\n    )
    END(end)
        WHITESPACE(\n)
EOF
    WHITESPACE(\n\n)
]]