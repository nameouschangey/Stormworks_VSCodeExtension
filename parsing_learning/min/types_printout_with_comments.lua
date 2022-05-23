a=[[
EXPCHAIN
    IDENTIFIER(require)
    FUNCTIONCALL
        OPENBRACKET(()
        STRING("Parsing.lex_tokenlist")
        CLOSEBRACKET())
LOCAL_ASSIGNMENT
    LOCAL(local)
        WHITESPACE(\n)
    IDENTIFIER(T)
        WHITESPACE( )
    ASSIGN(=)
        WHITESPACE( )
    EXPCHAIN
        IDENTIFIER(LBTokenTypes)
            WHITESPACE( )
GLOBAL_ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(LBSymbolTypes)
            WHITESPACE(\n\n\n)
    ASSIGN(=)
        WHITESPACE( )
    TABLEDEF
        OPENCURLY({)
            WHITESPACE( )
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GLOBAL_NAMEDFUNCTIONDEF)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(     )
            STRING("GLOBAL_NAMEDFUNCTIONDEF")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(LOCAL_NAMEDFUNCTIONDEF)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(      )
            STRING("LOCAL_NAMEDFUNCTIONDEF")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GLOBAL_ASSIGNMENT)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE(           )
            STRING("GLOBAL_ASSIGNMENT")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(LOCAL_ASSIGNMENT)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(            )
            STRING("LOCAL_ASSIGNMENT")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(FUNCTIONDEF)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE(         )
            STRING("ANON_FUNCTIONDEF")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(FUNCTIONDEF_PARAMS)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(  )
            STRING("FUNCTIONDEF_PARAMS")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(TABLEDEF)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE(            )
            STRING("TABLEDEF")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(WHILE_LOOP)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE(          )
            STRING("WHILE_LOOP")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(FOR_LOOP)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(            )
            STRING("FOR_LOOP")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(DO_END)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(              )
            STRING("DO_END")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(REPEAT_UNTIL)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(        )
            STRING("REPEAT_UNTIL")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(IF_STATEMENT)
                WHITESPACE( \n    )
            ASSIGN(=)
                WHITESPACE(        )
            STRING("IF_STATEMENT")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(IF_CONDITION)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(        )
            STRING("IF_CONDITION")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(PARENTHESIS)
                WHITESPACE(\n    \n    )
            ASSIGN(=)
                WHITESPACE(         )
            STRING("PARENTHESIS")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(EXPCHAIN)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(            )
            STRING("EXPCHAIN")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(OPERATORCHAIN)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE(       )
            STRING("OPERATORCHAIN")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ORCHAIN)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(             )
            STRING("ORCHAIN")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ANDCHAIN)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(            )
            STRING("ANDCHAIN")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(VALUECHAIN)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(          )
            STRING("VALUECHAIN")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(NUMCHAIN)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(            )
            STRING("NUMCHAIN")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(STRINGCHAIN)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(         )
            STRING("STRINGCONCAT")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(BOOLCHAIN)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(        )
            STRING("BOOLCHAIN")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(SQUARE_BRACKETS)
                WHITESPACE(\n    \n\n    )
            ASSIGN(=)
                WHITESPACE(     )
            STRING("SQUARE_BRACKETS")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(FUNCTIONCALL)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(        )
            STRING("FUNCTIONCALL")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(PARAM)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE(               )
            STRING("PARAM")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GOTOLABEL)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(           )
            STRING("GOTOLABEL")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GOTOSTATEMENT)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(       )
            STRING("GOTOSTATEMENT")
                WHITESPACE( )
        COMMA(,)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(LBTAG)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE(               )
            STRING("LBTAG")
                WHITESPACE( )
        COMMA(,)
        CLOSECURLY(})
            WHITESPACE(\n    )
LOCAL_ASSIGNMENT
    LOCAL(local)
        WHITESPACE(\n)
    IDENTIFIER(S)
        WHITESPACE( )
    ASSIGN(=)
        WHITESPACE( )
    EXPCHAIN
        IDENTIFIER(LBSymbolTypes)
            WHITESPACE( )
GLOBAL_ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(Parse)
            WHITESPACE(\n\n)
            COMMENT(---@class Parse)
            WHITESPACE(\n)
            COMMENT(---@field parent Parse)
            WHITESPACE(\n)
            COMMENT(---@field tokens LBToken[])
            WHITESPACE(\n)
            COMMENT(---@field symbol LBToken)
            WHITESPACE(\n)
            COMMENT(---@field i number)
            WHITESPACE(\n)
            COMMENT(---@field isReturnableScope boolean defined the type of scope, function or loop or none; for return and break keywords)
            WHITESPACE(\n)
            COMMENT(---@field isLoopScope boolean)
            WHITESPACE(\n)
            COMMENT(---@field errorObj any)
            WHITESPACE(\n)
            COMMENT(---@field cache any)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE( )
    TABLEDEF
        OPENCURLY({)
            WHITESPACE( )
        GLOBAL_ASSIGNMENT
            IDENTIFIER(new)
                WHITESPACE(\n    )
                COMMENT(---@return Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(this)
                    COMMA(,)
                    IDENTIFIER(symboltype)
                        WHITESPACE( )
                    COMMA(,)
                    IDENTIFIER(tokens)
                        WHITESPACE( )
                    COMMA(,)
                    IDENTIFIER(i)
                        WHITESPACE( )
                    COMMA(,)
                    IDENTIFIER(parent)
                        WHITESPACE( )
                    CLOSEBRACKET())
                RETURN(return)
                    WHITESPACE(\n        )
                    COMMENT(-- hardcoded class instantiation for performance, as it's called very often)
                    WHITESPACE(\n        )
                TABLEDEF
                    OPENCURLY({)
                        WHITESPACE( )
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(i)
                            WHITESPACE(\n            )
                            COMMENT(-- fields)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        ORCHAIN
                            EXPCHAIN
                                IDENTIFIER(i)
                                    WHITESPACE( )
                            OR(or)
                                WHITESPACE( )
                            NUMBER(1)
                                WHITESPACE( )
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(tokens)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(tokens)
                                WHITESPACE( )
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(symbol)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(LBToken)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(new)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(symboltype)
                                CLOSEBRACKET())
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(parent)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parent)
                                WHITESPACE( )
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(isReturnableScope)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        ORCHAIN
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(parent)
                                        WHITESPACE( )
                                AND(and)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parent)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(isReturnableScope)
                            OR(or)
                                WHITESPACE( )
                            FALSE(false)
                                WHITESPACE( )
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(isLoopScope)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        ORCHAIN
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(parent)
                                        WHITESPACE( )
                                AND(and)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parent)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(isLoopScope)
                            OR(or)
                                WHITESPACE( )
                            FALSE(false)
                                WHITESPACE( )
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(cache)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        ORCHAIN
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(parent)
                                        WHITESPACE( )
                                AND(and)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parent)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(cache)
                            OR(or)
                                WHITESPACE( )
                            TABLEDEF
                                OPENCURLY({)
                                    WHITESPACE( )
                                CLOSECURLY(})
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(branch)
                            WHITESPACE(\n\n            )
                            COMMENT(-- functions)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(branch)
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(commit)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(commit)
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(error)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(error)
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(match)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(match)
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(consume)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(consume)
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(tryConsume)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(tryConsume)
                    COMMA(,)
                    GLOBAL_ASSIGNMENT
                        IDENTIFIER(tryConsumeAs)
                            WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(tryConsumeAs)
                    COMMA(,)
                    CLOSECURLY(})
                        WHITESPACE(\n        )
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(branch)
                WHITESPACE(\n\n    )
                COMMENT(---@return Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(this)
                    COMMA(,)
                    IDENTIFIER(symboltype)
                        WHITESPACE( )
                    CLOSEBRACKET())
                RETURN(return)
                    WHITESPACE(\n        )
                EXPCHAIN
                    IDENTIFIER(Parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(new)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        EXPCHAIN
                            IDENTIFIER(symboltype)
                        COMMA(,)
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(tokens)
                        COMMA(,)
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(i)
                        COMMA(,)
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(commit)
                WHITESPACE(\n\n    )
                COMMENT(---@param this Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(this)
                    CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(this)
                            WHITESPACE( )
                        DOTACCESS(.)
                        IDENTIFIER(parent)
                    THEN(then)
                        WHITESPACE( )
                    LOCAL_ASSIGNMENT
                        LOCAL(local)
                            WHITESPACE(\n            )
                        IDENTIFIER(parentSymbol)
                            WHITESPACE( )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(parent)
                            DOTACCESS(.)
                            IDENTIFIER(symbol)
                    LOCAL_ASSIGNMENT
                        LOCAL(local)
                            WHITESPACE(\n            )
                        IDENTIFIER(thisSymbol)
                            WHITESPACE( )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(symbol)
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n            )
                        ORCHAIN
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(thisSymbol)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(type)
                            OR(or)
                                WHITESPACE( )
                            BOOLCHAIN
                                EXPCHAIN
                                    IDENTIFIER(parentSymbol)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(type)
                                BOOLOP(==)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(thisSymbol)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(type)
                        THEN(then)
                            WHITESPACE( )
                        FOR_LOOP
                            FOR(for)
                                WHITESPACE(\n                )
                            IDENTIFIER(i)
                                WHITESPACE( )
                            ASSIGN(=)
                            NUMBER(1)
                            COMMA(,)
                            NUMCHAIN
                                MATHOP_UNARY(#)
                                EXPCHAIN
                                    IDENTIFIER(thisSymbol)
                            DO(do)
                                WHITESPACE( )
                            GLOBAL_ASSIGNMENT
                                EXPCHAIN
                                    IDENTIFIER(parentSymbol)
                                        WHITESPACE(\n                    )
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        NUMCHAIN
                                            NUMCHAIN
                                                MATHOP_UNARY(#)
                                                EXPCHAIN
                                                    IDENTIFIER(parentSymbol)
                                            MATHOP(+)
                                            NUMBER(1)
                                        CLOSESQUARE(])
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(thisSymbol)
                                        WHITESPACE( )
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        EXPCHAIN
                                            IDENTIFIER(i)
                                        CLOSESQUARE(])
                            END(end)
                                WHITESPACE(\n                )
                        ELSE(else)
                            WHITESPACE(\n            )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(this)
                                    WHITESPACE(\n                )
                                DOTACCESS(.)
                                IDENTIFIER(parent)
                                DOTACCESS(.)
                                IDENTIFIER(symbol)
                                SQUARE_BRACKETS
                                    OPENSQUARE([)
                                    NUMCHAIN
                                        NUMCHAIN
                                            MATHOP_UNARY(#)
                                            EXPCHAIN
                                                IDENTIFIER(this)
                                                DOTACCESS(.)
                                                IDENTIFIER(parent)
                                                DOTACCESS(.)
                                                IDENTIFIER(symbol)
                                        MATHOP(+)
                                        NUMBER(1)
                                    CLOSESQUARE(])
                            ASSIGN(=)
                                WHITESPACE( )
                            EXPCHAIN
                                IDENTIFIER(this)
                                    WHITESPACE( )
                                DOTACCESS(.)
                                IDENTIFIER(symbol)
                        END(end)
                            WHITESPACE(\n            )
                    GLOBAL_ASSIGNMENT
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE(\n            )
                            DOTACCESS(.)
                            IDENTIFIER(parent)
                            DOTACCESS(.)
                            IDENTIFIER(i)
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(i)
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        )
                TRUE(true)
                    WHITESPACE( )
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(error)
                WHITESPACE(\n\n    )
                COMMENT(---@param this Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(this)
                    COMMA(,)
                    IDENTIFIER(message)
                        WHITESPACE( )
                    CLOSEBRACKET())
                LOCAL_ASSIGNMENT
                    LOCAL(local)
                        WHITESPACE(\n        )
                    IDENTIFIER(lineInfo)
                        WHITESPACE( )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(this)
                            WHITESPACE( )
                        DOTACCESS(.)
                        IDENTIFIER(tokens)
                        SQUARE_BRACKETS
                            OPENSQUARE([)
                            EXPCHAIN
                                IDENTIFIER(this)
                                DOTACCESS(.)
                                IDENTIFIER(i)
                            CLOSESQUARE(])
                        DOTACCESS(.)
                        IDENTIFIER(lineInfo)
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ORCHAIN
                        PARENTHESIS
                            OPENBRACKET(()
                                WHITESPACE( )
                            BOOLCHAIN
                                NOT(not)
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(errorObj)
                            CLOSEBRACKET())
                        OR(or)
                            WHITESPACE( )
                        PARENTHESIS
                            OPENBRACKET(()
                                WHITESPACE( )
                            BOOLCHAIN
                                EXPCHAIN
                                    IDENTIFIER(lineInfo)
                                    DOTACCESS(.)
                                    IDENTIFIER(index)
                                BOOLOP(>)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(errorObj)
                                    DOTACCESS(.)
                                    IDENTIFIER(index)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    GLOBAL_ASSIGNMENT
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE(\n            )
                            DOTACCESS(.)
                            IDENTIFIER(errorObj)
                        ASSIGN(=)
                            WHITESPACE( )
                        TABLEDEF
                            OPENCURLY({)
                                WHITESPACE( )
                            GLOBAL_ASSIGNMENT
                                IDENTIFIER(owner)
                                    WHITESPACE(\n                )
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                            COMMA(,)
                            GLOBAL_ASSIGNMENT
                                IDENTIFIER(message)
                                    WHITESPACE(\n                )
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(message)
                                        WHITESPACE( )
                            COMMA(,)
                            GLOBAL_ASSIGNMENT
                                IDENTIFIER(i)
                                    WHITESPACE(\n                )
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(i)
                            COMMA(,)
                            GLOBAL_ASSIGNMENT
                                IDENTIFIER(index)
                                    WHITESPACE(\n                )
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(lineInfo)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(index)
                            COMMA(,)
                            GLOBAL_ASSIGNMENT
                                IDENTIFIER(line)
                                    WHITESPACE(\n                )
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(lineInfo)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(line)
                            COMMA(,)
                            GLOBAL_ASSIGNMENT
                                IDENTIFIER(column)
                                    WHITESPACE(\n                )
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(lineInfo)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(column)
                            COMMA(,)
                            GLOBAL_ASSIGNMENT
                                IDENTIFIER(toString)
                                    WHITESPACE(\n                )
                                ASSIGN(=)
                                    WHITESPACE( )
                                ANON_FUNCTIONDEF
                                    FUNCTION(function)
                                        WHITESPACE( )
                                    FUNCTIONDEF_PARAMS
                                        OPENBRACKET(()
                                        IDENTIFIER(err)
                                        CLOSEBRACKET())
                                    RETURN(return)
                                        WHITESPACE(\n                    )
                                    STRINGCONCAT
                                        STRING("line: ")
                                            WHITESPACE( )
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        EXPCHAIN
                                            IDENTIFIER(err)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(line)
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        STRING(", column: ")
                                            WHITESPACE( )
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        EXPCHAIN
                                            IDENTIFIER(err)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(column)
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        STRING("\n")
                                            WHITESPACE( )
                                        STRINGOP(..)
                                            WHITESPACE(\n                        )
                                        STRING("at token ")
                                            WHITESPACE( )
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        EXPCHAIN
                                            IDENTIFIER(err)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(i)
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        STRING(": ")
                                            WHITESPACE( )
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        EXPCHAIN
                                            IDENTIFIER(tostring)
                                                WHITESPACE( )
                                            FUNCTIONCALL
                                                OPENBRACKET(()
                                                EXPCHAIN
                                                    IDENTIFIER(this)
                                                    DOTACCESS(.)
                                                    IDENTIFIER(tokens)
                                                    SQUARE_BRACKETS
                                                        OPENSQUARE([)
                                                        EXPCHAIN
                                                            IDENTIFIER(err)
                                                            DOTACCESS(.)
                                                            IDENTIFIER(i)
                                                        CLOSESQUARE(])
                                                    DOTACCESS(.)
                                                    IDENTIFIER(raw)
                                                CLOSEBRACKET())
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        STRING("\n")
                                            WHITESPACE( )
                                        STRINGOP(..)
                                            WHITESPACE(\n                        )
                                        EXPCHAIN
                                            IDENTIFIER(message)
                                                WHITESPACE( )
                                        STRINGOP(..)
                                            WHITESPACE( )
                                        STRING("\n")
                                            WHITESPACE( )
                                    END(end)
                                        WHITESPACE(\n                )
                            SEMICOLON(;)
                            CLOSECURLY(})
                                WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ORCHAIN
                        PARENTHESIS
                            OPENBRACKET(()
                                WHITESPACE( )
                            BOOLCHAIN
                                NOT(not)
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(parent)
                                    DOTACCESS(.)
                                    IDENTIFIER(errorObj)
                            CLOSEBRACKET())
                        OR(or)
                            WHITESPACE( )
                        PARENTHESIS
                            OPENBRACKET(()
                                WHITESPACE( )
                            BOOLCHAIN
                                EXPCHAIN
                                    IDENTIFIER(this)
                                    DOTACCESS(.)
                                    IDENTIFIER(errorObj)
                                    DOTACCESS(.)
                                    IDENTIFIER(index)
                                BOOLOP(>)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(parent)
                                    DOTACCESS(.)
                                    IDENTIFIER(errorObj)
                                    DOTACCESS(.)
                                    IDENTIFIER(index)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    GLOBAL_ASSIGNMENT
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE(\n            )
                            DOTACCESS(.)
                            IDENTIFIER(parent)
                            DOTACCESS(.)
                            IDENTIFIER(errorObj)
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(errorObj)
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        )
                FALSE(false)
                    WHITESPACE( )
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(match)
                WHITESPACE(\n\n    )
                COMMENT(---@return boolean)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(this)
                    COMMA(,)
                    VARARGS(...)
                        WHITESPACE( )
                    CLOSEBRACKET())
                RETURN(return)
                    WHITESPACE(\n        )
                EXPCHAIN
                    IDENTIFIER(is)
                        WHITESPACE( )
                    FUNCTIONCALL
                        OPENBRACKET(()
                        EXPCHAIN
                            IDENTIFIER(this)
                            DOTACCESS(.)
                            IDENTIFIER(tokens)
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                EXPCHAIN
                                    IDENTIFIER(this)
                                    DOTACCESS(.)
                                    IDENTIFIER(i)
                                CLOSESQUARE(])
                            DOTACCESS(.)
                            IDENTIFIER(type)
                        COMMA(,)
                        VARARGS(...)
                            WHITESPACE( )
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(tryConsume)
                WHITESPACE(\n\n    )
                COMMENT(---@param this Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(this)
                    COMMA(,)
                    VARARGS(...)
                        WHITESPACE( )
                    CLOSEBRACKET())
                LOCAL_ASSIGNMENT
                    LOCAL(local)
                        WHITESPACE(\n        )
                    IDENTIFIER(rules)
                        WHITESPACE( )
                    ASSIGN(=)
                        WHITESPACE( )
                    TABLEDEF
                        OPENCURLY({)
                            WHITESPACE( )
                        VARARGS(...)
                        CLOSECURLY(})
                FOR_LOOP
                    FOR(for)
                        WHITESPACE(\n        )
                    IDENTIFIER(irules)
                        WHITESPACE( )
                    ASSIGN(=)
                    NUMBER(1)
                    COMMA(,)
                    NUMCHAIN
                        MATHOP_UNARY(#)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(rules)
                    DO(do)
                        WHITESPACE( )
                    LOCAL_ASSIGNMENT
                        LOCAL(local)
                            WHITESPACE(\n            )
                        IDENTIFIER(rule)
                            WHITESPACE( )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(rules)
                                WHITESPACE( )
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                EXPCHAIN
                                    IDENTIFIER(irules)
                                CLOSESQUARE(])
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        BOOLCHAIN
                            EXPCHAIN
                                IDENTIFIER(type)
                                    WHITESPACE( )
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(rule)
                                    CLOSEBRACKET())
                            BOOLOP(==)
                                WHITESPACE( )
                            STRING("function")
                                WHITESPACE( )
                        THEN(then)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(cache)
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        EXPCHAIN
                                            IDENTIFIER(rule)
                                        CLOSESQUARE(])
                            THEN(then)
                                WHITESPACE( )
                            GLOBAL_ASSIGNMENT
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE(\n                    )
                                    DOTACCESS(.)
                                    IDENTIFIER(cache)
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        EXPCHAIN
                                            IDENTIFIER(rule)
                                        CLOSESQUARE(])
                                ASSIGN(=)
                                    WHITESPACE( )
                                TABLEDEF
                                    OPENCURLY({)
                                        WHITESPACE( )
                                    CLOSECURLY(})
                            END(end)
                                WHITESPACE(\n                )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n\n                )
                            BOOLCHAIN
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(cache)
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        EXPCHAIN
                                            IDENTIFIER(rule)
                                        CLOSESQUARE(])
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        EXPCHAIN
                                            IDENTIFIER(this)
                                            DOTACCESS(.)
                                            IDENTIFIER(i)
                                        CLOSESQUARE(])
                                BOOLOP(~=)
                                    WHITESPACE( )
                                FALSE(false)
                                    WHITESPACE( )
                            THEN(then)
                                WHITESPACE( )
                            LOCAL_ASSIGNMENT
                                LOCAL(local)
                                    WHITESPACE(\n                    )
                                IDENTIFIER(result)
                                    WHITESPACE( )
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(rule)
                                        WHITESPACE( )
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(this)
                                        CLOSEBRACKET())
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n                    \n                    )
                                EXPCHAIN
                                    IDENTIFIER(result)
                                        WHITESPACE( )
                                THEN(then)
                                    WHITESPACE( )
                                GLOBAL_ASSIGNMENT
                                    EXPCHAIN
                                        IDENTIFIER(this)
                                            WHITESPACE(\n                        )
                                        DOTACCESS(.)
                                        IDENTIFIER(cache)
                                        SQUARE_BRACKETS
                                            OPENSQUARE([)
                                            EXPCHAIN
                                                IDENTIFIER(rule)
                                            CLOSESQUARE(])
                                        SQUARE_BRACKETS
                                            OPENSQUARE([)
                                            EXPCHAIN
                                                IDENTIFIER(this)
                                                DOTACCESS(.)
                                                IDENTIFIER(i)
                                            CLOSESQUARE(])
                                    ASSIGN(=)
                                        WHITESPACE( )
                                    TRUE(true)
                                        WHITESPACE( )
                                RETURN(return)
                                    WHITESPACE(\n                        )
                                TRUE(true)
                                    WHITESPACE( )
                                ELSE(else)
                                    WHITESPACE(\n                    )
                                GLOBAL_ASSIGNMENT
                                    EXPCHAIN
                                        IDENTIFIER(this)
                                            WHITESPACE(\n                        )
                                        DOTACCESS(.)
                                        IDENTIFIER(cache)
                                        SQUARE_BRACKETS
                                            OPENSQUARE([)
                                            EXPCHAIN
                                                IDENTIFIER(rule)
                                            CLOSESQUARE(])
                                        SQUARE_BRACKETS
                                            OPENSQUARE([)
                                            EXPCHAIN
                                                IDENTIFIER(this)
                                                DOTACCESS(.)
                                                IDENTIFIER(i)
                                            CLOSESQUARE(])
                                    ASSIGN(=)
                                        WHITESPACE( )
                                    FALSE(false)
                                        WHITESPACE( )
                                END(end)
                                    WHITESPACE(\n                    )
                            END(end)
                                WHITESPACE(\n                )
                        ELSE(else)
                            WHITESPACE(\n            )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(is)
                                    WHITESPACE( )
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(this)
                                        DOTACCESS(.)
                                        IDENTIFIER(tokens)
                                        SQUARE_BRACKETS
                                            OPENSQUARE([)
                                            EXPCHAIN
                                                IDENTIFIER(this)
                                                DOTACCESS(.)
                                                IDENTIFIER(i)
                                            CLOSESQUARE(])
                                        DOTACCESS(.)
                                        IDENTIFIER(type)
                                    COMMA(,)
                                    VARARGS(...)
                                        WHITESPACE( )
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            GLOBAL_ASSIGNMENT
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE(\n                    )
                                    DOTACCESS(.)
                                    IDENTIFIER(symbol)
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        NUMCHAIN
                                            NUMCHAIN
                                                MATHOP_UNARY(#)
                                                EXPCHAIN
                                                    IDENTIFIER(this)
                                                    DOTACCESS(.)
                                                    IDENTIFIER(symbol)
                                            MATHOP(+)
                                            NUMBER(1)
                                        CLOSESQUARE(])
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(tokens)
                                    SQUARE_BRACKETS
                                        OPENSQUARE([)
                                        EXPCHAIN
                                            IDENTIFIER(this)
                                            DOTACCESS(.)
                                            IDENTIFIER(i)
                                        CLOSESQUARE(])
                            GLOBAL_ASSIGNMENT
                                EXPCHAIN
                                    IDENTIFIER(this)
                                        WHITESPACE(\n                    )
                                    DOTACCESS(.)
                                    IDENTIFIER(i)
                                ASSIGN(=)
                                    WHITESPACE( )
                                NUMCHAIN
                                    EXPCHAIN
                                        IDENTIFIER(this)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(i)
                                    MATHOP(+)
                                        WHITESPACE( )
                                    NUMBER(1)
                                        WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            TRUE(true)
                                WHITESPACE( )
                            ELSE(else)
                                WHITESPACE(\n                )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            FALSE(false)
                                WHITESPACE( )
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        )
                FALSE(false)
                    WHITESPACE( )
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(tryConsumeAs)
                WHITESPACE(\n\n    )
                COMMENT(---@param this Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(this)
                    COMMA(,)
                    IDENTIFIER(symboltype)
                        WHITESPACE( )
                    COMMA(,)
                    VARARGS(...)
                        WHITESPACE( )
                    CLOSEBRACKET())
                LOCAL_ASSIGNMENT
                    LOCAL(local)
                        WHITESPACE(\n        )
                    IDENTIFIER(result)
                        WHITESPACE( )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(this)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            VARARGS(...)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(result)
                            WHITESPACE( )
                    THEN(then)
                        WHITESPACE( )
                    GLOBAL_ASSIGNMENT
                        EXPCHAIN
                            IDENTIFIER(this)
                                WHITESPACE(\n            )
                            DOTACCESS(.)
                            IDENTIFIER(symbol)
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                NUMCHAIN
                                    MATHOP_UNARY(#)
                                    EXPCHAIN
                                        IDENTIFIER(this)
                                        DOTACCESS(.)
                                        IDENTIFIER(symbol)
                                CLOSESQUARE(])
                            DOTACCESS(.)
                            IDENTIFIER(type)
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(symboltype)
                                WHITESPACE( )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        )
                EXPCHAIN
                    IDENTIFIER(result)
                        WHITESPACE( )
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        CLOSECURLY(})
            WHITESPACE(\n)
GLOBAL_ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(LBExpressions)
            WHITESPACE(\n\n)
            COMMENT(---@class Expressions)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE( )
    TABLEDEF
        OPENCURLY({)
            WHITESPACE( )
        GLOBAL_ASSIGNMENT
            IDENTIFIER(Program)
                WHITESPACE(\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                LOCAL_ASSIGNMENT
                    LOCAL(local)
                        WHITESPACE(\n        )
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE(\n\n        )
                    COLONACCESS(:)
                    IDENTIFIER(tryConsume)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        EXPCHAIN
                            IDENTIFIER(LBExpressions)
                            DOTACCESS(.)
                            IDENTIFIER(genBody)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(EOF)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(RETURN)
                                CLOSEBRACKET())
                        CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(ReturnStatement)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    END(end)
                        WHITESPACE(\n            \n        )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(EOF)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Did not reach EOF")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(Statement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(STATEMENT)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ORCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(SEMICOLON)
                                CLOSEBRACKET())
                        OR(or)
                            WHITESPACE(\n        )
                        ANDCHAIN
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                DOTACCESS(.)
                                IDENTIFIER(isLoopScope)
                            AND(and)
                                WHITESPACE( )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(BREAK)
                                    CLOSEBRACKET())
                        OR(or)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(LocalNamedFunctionDefinition)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(GlobalNamedFunctionDefinition)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(IfStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(ForLoopStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(ForInLoopStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(WhileLoopStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(RepeatUntilStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(DoEndStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(GotoLabelStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(GotoStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(ProcessorLBTagSection)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(FunctionCallStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(GlobalAssignmentStatement)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(LocalAssignmentStatement)
                                COMMA(,)
                                ORCHAIN
                                    ANDCHAIN
                                        EXPCHAIN
                                            IDENTIFIER(parse)
                                                WHITESPACE(\n            )
                                            DOTACCESS(.)
                                            IDENTIFIER(isReturnableScope)
                                        AND(and)
                                            WHITESPACE( )
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(ReturnStatement)
                                    OR(or)
                                        WHITESPACE( )
                                    NIL(nil)
                                        WHITESPACE( )
                                CLOSEBRACKET())
                                    WHITESPACE(\n        )
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid statement")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(SquareBracketsIndex)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(SQUARE_BRACKETS)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(OPENSQUARE)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(Expression)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(CLOSESQUARE)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid square-bracket index")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ParenthesisExpression)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(PARENTHESIS)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(OPENBRACKET)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(Expression)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(CLOSEBRACKET)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid parenthesis expression")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(TableDef)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(TABLEDEF)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(OPENCURLY)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n            \n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(TableValueInitialization)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        WHILE_LOOP
                            WHILE(while)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(COMMA)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(SEMICOLON)
                                    CLOSEBRACKET())
                            DO(do)
                                WHITESPACE( )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n                    )
                                BOOLCHAIN
                                    NOT(not)
                                        WHITESPACE( )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(LBExpressions)
                                                DOTACCESS(.)
                                                IDENTIFIER(TableValueInitialization)
                                            CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                BREAK(break)
                                    WHITESPACE(\n                        )
                                SEMICOLON(;)
                                END(end)
                                    WHITESPACE( )
                                    COMMENT(-- it's valid to end on a comma/semi-colon)
                                    WHITESPACE(\n                    )
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            \n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(CLOSECURLY)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid table definition")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(FunctionDefParenthesis)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(FUNCTIONDEF_PARAMS)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(OPENBRACKET)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        PARENTHESIS
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(parse)
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(IDENTIFIER)
                                    CLOSEBRACKET())
                            CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        WHILE_LOOP
                            WHILE(while)
                                WHITESPACE(\n                \n                )
                            PARENTHESIS
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(COMMA)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                            DO(do)
                                WHITESPACE( )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n                    )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(VARARGS)
                                        CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                BREAK(break)
                                    WHITESPACE(\n                        )
                                END(end)
                                    WHITESPACE( )
                                    COMMENT(-- should be final parameter, so close brackets next)
                                    WHITESPACE(\n                    )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n                    )
                                BOOLCHAIN
                                    NOT(not)
                                        WHITESPACE( )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                DOTACCESS(.)
                                                IDENTIFIER(IDENTIFIER)
                                            CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                RETURN(return)
                                    WHITESPACE(\n                        )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(error)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        STRING("Expected parameter after ','")
                                        CLOSEBRACKET())
                                END(end)
                                    WHITESPACE(\n                    )
                            END(end)
                                WHITESPACE(\n                )
                        ELSEIF(elseif)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(VARARGS)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        END(end)
                            WHITESPACE(\n                )
                            COMMENT(-- nothing else to do, expect end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(CLOSEBRACKET)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid function-definition parenthesis")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ExpressionList)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                            COMMENT(-- a,b,c,d,e comma separated items)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(Expression)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(COMMA)
                                CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                            DOTACCESS(.)
                                            IDENTIFIER(Expression)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expression list must not leave trailing ','")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid expression-list")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ReturnStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(RETURN)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n\n            )
                            COMMENT(-- optional expression-list)
                            WHITESPACE(\n            )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(ExpressionList)
                            CLOSEBRACKET())
                    RETURN(return)
                        WHITESPACE(\n\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid return statement")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(AnonymousFunctionDef)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(FUNCTIONDEF)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(FUNCTION)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE( \n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(FunctionDefParenthesis)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    GLOBAL_ASSIGNMENT
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n\n            )
                            DOTACCESS(.)
                            IDENTIFIER(isReturnableScope)
                        ASSIGN(=)
                            WHITESPACE( )
                        TRUE(true)
                            WHITESPACE( )
                    SEMICOLON(;)
                    GLOBAL_ASSIGNMENT
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n            )
                            DOTACCESS(.)
                            IDENTIFIER(isLoopScope)
                        ASSIGN(=)
                            WHITESPACE( )
                        FALSE(false)
                            WHITESPACE( )
                    SEMICOLON(;)
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n            )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(genBody)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(END)
                                    CLOSEBRACKET())
                            CLOSEBRACKET())
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(END)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid anonymous function definition")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GlobalNamedFunctionDefinition)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    COMMA(,)
                    VARARGS(...)
                        WHITESPACE( )
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(GLOBAL_NAMEDFUNCTIONDEF)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        \n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(FUNCTION)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n\n            )
                            COMMENT(-- for each ".", require a <name> after)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(DOTACCESS)
                                CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(IDENTIFIER)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected identifier after '.' ")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                            COMMENT(-- if : exists, require <name> after)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(COLONACCESS)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(IDENTIFIER)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected final identifier after ':' ")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(FunctionDefParenthesis)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                )
                                DOTACCESS(.)
                                IDENTIFIER(isReturnableScope)
                            ASSIGN(=)
                                WHITESPACE( )
                            TRUE(true)
                                WHITESPACE( )
                        SEMICOLON(;)
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                )
                                DOTACCESS(.)
                                IDENTIFIER(isLoopScope)
                            ASSIGN(=)
                                WHITESPACE( )
                            FALSE(false)
                                WHITESPACE( )
                        SEMICOLON(;)
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n                )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(genBody)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(END)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(END)
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(commit)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid named-function definition")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(LocalNamedFunctionDefinition)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    COMMA(,)
                    VARARGS(...)
                        WHITESPACE( )
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(LOCAL_NAMEDFUNCTIONDEF)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        \n        )
                        COMMENT(-- optionally local)
                        WHITESPACE(\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(LOCAL)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n           )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(FUNCTION)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(match)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(DOTACCESS)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(COLONACCESS)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(error)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                STRING("Local function definition must only be simple identifier (no '.'/':') ")
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(FunctionDefParenthesis)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                )
                                DOTACCESS(.)
                                IDENTIFIER(isReturnableScope)
                            ASSIGN(=)
                                WHITESPACE( )
                            TRUE(true)
                                WHITESPACE( )
                        SEMICOLON(;)
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                )
                                DOTACCESS(.)
                                IDENTIFIER(isLoopScope)
                            ASSIGN(=)
                                WHITESPACE( )
                            FALSE(false)
                                WHITESPACE( )
                        SEMICOLON(;)
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n                )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(genBody)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(END)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(END)
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(commit)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid named-function definition")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(OperatorChain)
                WHITESPACE(\n\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        \n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(OrChain)
                            COMMA(,)
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                    WHITESPACE( )
                                DOTACCESS(.)
                                IDENTIFIER(AndChain)
                            COMMA(,)
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                    WHITESPACE( )
                                DOTACCESS(.)
                                IDENTIFIER(ValueChain)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        \n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid operator chain")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(OrChain)
                WHITESPACE(\n    \n\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(ORCHAIN)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(AndChain)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(ValueChain)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(SingleExpression)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(OR)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(AndChain)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(ValueChain)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(SingleExpression)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(OR)
                                CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                            DOTACCESS(.)
                                            IDENTIFIER(AndChain)
                                        COMMA(,)
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(ValueChain)
                                        COMMA(,)
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(SingleExpression)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected expression following OR")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        \n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Not Or Chain")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(AndChain)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(ANDCHAIN)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(ValueChain)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(SingleExpression)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(AND)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(ValueChain)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(SingleExpression)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(AND)
                                CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                            DOTACCESS(.)
                                            IDENTIFIER(ValueChain)
                                        COMMA(,)
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(SingleExpression)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected expression following AND")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        \n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Not And Chain")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ValueChain)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                LOCAL_ASSIGNMENT
                    LOCAL(local)
                        WHITESPACE(\n        )
                    IDENTIFIER(isNumber)
                        WHITESPACE( )
                    COMMA(,)
                    IDENTIFIER(isBool)
                        WHITESPACE( )
                    COMMA(,)
                    IDENTIFIER(isString)
                        WHITESPACE( )
                SEMICOLON(;)
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(VALUECHAIN)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(SingleExpression)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n        \n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsumeAs)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(MATHOP)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(MIXED_MATHOP)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(MATHOP)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(isNumber)
                                    WHITESPACE(\n                )
                            ASSIGN(=)
                                WHITESPACE( )
                            TRUE(true)
                                WHITESPACE( )
                        ELSEIF(elseif)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(STRING_CONCAT)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(isString)
                                    WHITESPACE(\n                )
                            ASSIGN(=)
                                WHITESPACE( )
                            TRUE(true)
                                WHITESPACE( )
                        ELSEIF(elseif)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(COMPARISON)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(isBool)
                                    WHITESPACE(\n                )
                            ASSIGN(=)
                                WHITESPACE( )
                            TRUE(true)
                                WHITESPACE( )
                        ELSE(else)
                            WHITESPACE(\n            )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(error)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                STRING("Invalid value chain")
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(SingleExpression)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        WHILE_LOOP
                            WHILE(while)
                                WHITESPACE(\n\n                )
                            TRUE(true)
                                WHITESPACE( )
                            DO(do)
                                WHITESPACE( )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n                    )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsumeAs)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(MATHOP)
                                        COMMA(,)
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(MIXED_MATHOP)
                                        COMMA(,)
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                                WHITESPACE( )
                                            DOTACCESS(.)
                                            IDENTIFIER(MATHOP)
                                        CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                GLOBAL_ASSIGNMENT
                                    EXPCHAIN
                                        IDENTIFIER(isNumber)
                                            WHITESPACE(\n                        )
                                    ASSIGN(=)
                                        WHITESPACE( )
                                    TRUE(true)
                                        WHITESPACE( )
                                ELSEIF(elseif)
                                    WHITESPACE(\n                    )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(STRING_CONCAT)
                                        CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                GLOBAL_ASSIGNMENT
                                    EXPCHAIN
                                        IDENTIFIER(isString)
                                            WHITESPACE(\n                        )
                                    ASSIGN(=)
                                        WHITESPACE( )
                                    TRUE(true)
                                        WHITESPACE( )
                                ELSEIF(elseif)
                                    WHITESPACE(\n                    )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(COMPARISON)
                                        CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                GLOBAL_ASSIGNMENT
                                    EXPCHAIN
                                        IDENTIFIER(isBool)
                                            WHITESPACE(\n                        )
                                    ASSIGN(=)
                                        WHITESPACE( )
                                    TRUE(true)
                                        WHITESPACE( )
                                ELSE(else)
                                    WHITESPACE(\n                    )
                                BREAK(break)
                                    WHITESPACE(\n                        )
                                END(end)
                                    WHITESPACE(\n                    )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n           \n                    )
                                BOOLCHAIN
                                    NOT(not)
                                        WHITESPACE( )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(LBExpressions)
                                                DOTACCESS(.)
                                                IDENTIFIER(SingleExpression)
                                            CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                RETURN(return)
                                    WHITESPACE(\n                        )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(error)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        STRING("Invalid operator chain, missing final expression")
                                        CLOSEBRACKET())
                                END(end)
                                    WHITESPACE(\n                    )
                            END(end)
                                WHITESPACE(\n                )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                \n                )
                            EXPCHAIN
                                IDENTIFIER(isBool)
                                    WHITESPACE( )
                            THEN(then)
                                WHITESPACE( )
                            GLOBAL_ASSIGNMENT
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE(\n                    )
                                    DOTACCESS(.)
                                    IDENTIFIER(symbol)
                                    DOTACCESS(.)
                                    IDENTIFIER(type)
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(S)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(BOOLCHAIN)
                            ELSEIF(elseif)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(isString)
                                    WHITESPACE( )
                            THEN(then)
                                WHITESPACE( )
                            GLOBAL_ASSIGNMENT
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE(\n                    )
                                    DOTACCESS(.)
                                    IDENTIFIER(symbol)
                                    DOTACCESS(.)
                                    IDENTIFIER(type)
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(S)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(STRINGCHAIN)
                            ELSEIF(elseif)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(isNumber)
                                    WHITESPACE( )
                            THEN(then)
                                WHITESPACE( )
                            GLOBAL_ASSIGNMENT
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE(\n                    )
                                    DOTACCESS(.)
                                    IDENTIFIER(symbol)
                                    DOTACCESS(.)
                                    IDENTIFIER(type)
                                ASSIGN(=)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(S)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(NUMCHAIN)
                            ELSE(else)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(error)
                                    WHITESPACE(\n                    )
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("internal: unexpected chain operators, please review parser code for errors")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        RETURN(return)
                            WHITESPACE(\n\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid value chain")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(FunctionCallStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                        COMMENT(-- save a lot of duplication by finding a valid ExpChain and then backtracking)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(ExpressionChainedOperator)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    LOCAL_ASSIGNMENT
                        LOCAL(local)
                            WHITESPACE(\n            )
                        IDENTIFIER(lastChild)
                            WHITESPACE( )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(symbol)
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                NUMCHAIN
                                    MATHOP_UNARY(#)
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                        DOTACCESS(.)
                                        IDENTIFIER(symbol)
                                CLOSESQUARE(])
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n            )
                        ANDCHAIN
                            EXPCHAIN
                                IDENTIFIER(lastChild)
                                    WHITESPACE( )
                            AND(and)
                                WHITESPACE(\n            )
                            EXPCHAIN
                                IDENTIFIER(lastChild)
                                    WHITESPACE( )
                                SQUARE_BRACKETS
                                    OPENSQUARE([)
                                    NUMCHAIN
                                        MATHOP_UNARY(#)
                                        EXPCHAIN
                                            IDENTIFIER(lastChild)
                                    CLOSESQUARE(])
                            AND(and)
                                WHITESPACE(\n            )
                            EXPCHAIN
                                IDENTIFIER(is)
                                    WHITESPACE( )
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(lastChild)
                                        SQUARE_BRACKETS
                                            OPENSQUARE([)
                                            NUMCHAIN
                                                MATHOP_UNARY(#)
                                                EXPCHAIN
                                                    IDENTIFIER(lastChild)
                                            CLOSESQUARE(])
                                        DOTACCESS(.)
                                        IDENTIFIER(type)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(S)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(FUNCTIONCALL)
                                    CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid function call statement")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ExpressionChainedOperator)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                            COMMENT(-- a = (1+2)()()[1].123 param,func,func,accesschain,accesschain)
                            WHITESPACE(\n        )
                            COMMENT(-- singleExpressions can chain into infinite function calls, etc.)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(EXPCHAIN)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ORCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                        OR(or)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(ParenthesisExpression)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n            )
                        TRUE(true)
                            WHITESPACE( )
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(DOTACCESS)
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE( )
                                    COMMENT(-- .<name>)
                                    WHITESPACE(\n                    )
                                BOOLCHAIN
                                    NOT(not)
                                        WHITESPACE( )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                DOTACCESS(.)
                                                IDENTIFIER(IDENTIFIER)
                                            CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                RETURN(return)
                                    WHITESPACE(\n                        )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(error)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        STRING("Expected identifier after '.' ")
                                        CLOSEBRACKET())
                                END(end)
                                    WHITESPACE(\n                    )
                            ELSEIF(elseif)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(COLONACCESS)
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE( )
                                    COMMENT(-- :<name>(func) )
                                    WHITESPACE(\n                    )
                                BOOLCHAIN
                                    NOT(not)
                                        WHITESPACE( )
                                    PARENTHESIS
                                        OPENBRACKET(()
                                            WHITESPACE( )
                                        ANDCHAIN
                                            EXPCHAIN
                                                IDENTIFIER(parse)
                                                COLONACCESS(:)
                                                IDENTIFIER(tryConsume)
                                                FUNCTIONCALL
                                                    OPENBRACKET(()
                                                    EXPCHAIN
                                                        IDENTIFIER(T)
                                                        DOTACCESS(.)
                                                        IDENTIFIER(IDENTIFIER)
                                                    CLOSEBRACKET())
                                            AND(and)
                                                WHITESPACE(\n                        )
                                            EXPCHAIN
                                                IDENTIFIER(parse)
                                                    WHITESPACE( )
                                                COLONACCESS(:)
                                                IDENTIFIER(tryConsume)
                                                FUNCTIONCALL
                                                    OPENBRACKET(()
                                                    EXPCHAIN
                                                        IDENTIFIER(LBExpressions)
                                                        DOTACCESS(.)
                                                        IDENTIFIER(FunctionCallParenthesis)
                                                    CLOSEBRACKET())
                                        CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                RETURN(return)
                                    WHITESPACE(\n                        )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(error)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        STRING("Expected function call after ':'")
                                        CLOSEBRACKET())
                                END(end)
                                    WHITESPACE(\n                    )
                            ELSEIF(elseif)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                        DOTACCESS(.)
                                        IDENTIFIER(SquareBracketsIndex)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(FunctionCallParenthesis)
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            ELSE(else)
                                WHITESPACE( )
                                COMMENT(-- [123] or (a,b,c))
                                WHITESPACE(\n                    )
                                COMMENT(-- all OK)
                                WHITESPACE(\n                )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(commit)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    CLOSEBRACKET())
                            SEMICOLON(;)
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid expression chain")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(SingleExpression)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                            COMMENT(-- single expression, not lined by binary, e.g. a string, an identifier-chain, etc.)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                WHILE_LOOP
                    WHILE(while)
                        WHITESPACE(\n\n        )
                        COMMENT(-- clear any unary operators from the front)
                        WHITESPACE(\n        )
                    ORCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(NOT)
                                CLOSEBRACKET())
                        OR(or)
                            WHITESPACE(\n              )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsumeAs)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(UNARY_MATHOP)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(UNARY_MATHOP)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(MIXED_MATHOP)
                                CLOSEBRACKET())
                    DO(do)
                        WHITESPACE( )
                    LOCAL_ASSIGNMENT
                        LOCAL(local)
                            WHITESPACE(\n            )
                        IDENTIFIER(symbolJustAdded)
                            WHITESPACE( )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(symbol)
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                NUMCHAIN
                                    MATHOP_UNARY(#)
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                        DOTACCESS(.)
                                        IDENTIFIER(symbol)
                                CLOSESQUARE(])
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                            COMMENT(-- categorize this as a Math or Boolean expression (as these returns convert it))
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(is)
                                WHITESPACE( )
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(symbolJustAdded)
                                    DOTACCESS(.)
                                    IDENTIFIER(type)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(UNARY_MATHOP)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                )
                                DOTACCESS(.)
                                IDENTIFIER(symbol)
                                DOTACCESS(.)
                                IDENTIFIER(type)
                            ASSIGN(=)
                                WHITESPACE( )
                            EXPCHAIN
                                IDENTIFIER(S)
                                    WHITESPACE( )
                                DOTACCESS(.)
                                IDENTIFIER(NUMCHAIN)
                        ELSE(else)
                            WHITESPACE(\n            )
                        GLOBAL_ASSIGNMENT
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                )
                                DOTACCESS(.)
                                IDENTIFIER(symbol)
                                DOTACCESS(.)
                                IDENTIFIER(type)
                            ASSIGN(=)
                                WHITESPACE( )
                            EXPCHAIN
                                IDENTIFIER(S)
                                    WHITESPACE( )
                                DOTACCESS(.)
                                IDENTIFIER(BOOLCHAIN)
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ORCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(VARARGS)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(STRING)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(NUMBER)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(HEX)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(TRUE)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(FALSE)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(T)
                                        WHITESPACE( )
                                    DOTACCESS(.)
                                    IDENTIFIER(NIL)
                                CLOSEBRACKET())
                        OR(or)
                            COMMENT(-- hard-coded value)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(ParenthesisExpression)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(ExpressionChainedOperator)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE( )
                                        COMMENT(-- (exp.index.index.index[index][index](func)(func)(func)))
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(TableDef)
                                COMMA(,)
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                        WHITESPACE(\n            )
                                    DOTACCESS(.)
                                    IDENTIFIER(AnonymousFunctionDef)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid single-expression")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(Expression)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                            COMMENT(-- identifier.access)
                            WHITESPACE(\n        )
                            COMMENT(-- expression mathop|concat expression chain)
                            WHITESPACE(\n        )
                            COMMENT(-- parenthesis -> expression)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                    WHITESPACE(\n            )
                                DOTACCESS(.)
                                IDENTIFIER(OperatorChain)
                            COMMA(,)
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                    WHITESPACE( )
                                    COMMENT(-- (exp op exp) (infinite chain-> single_exp op (exp op exp)) etc.)
                                    WHITESPACE(\n            )
                                DOTACCESS(.)
                                IDENTIFIER(SingleExpression)
                            CLOSEBRACKET())
                                WHITESPACE(\n        )
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid expression")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(genBody)
                WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    VARARGS(...)
                    CLOSEBRACKET())
                LOCAL_ASSIGNMENT
                    LOCAL(local)
                        WHITESPACE(\n        )
                    IDENTIFIER(args)
                        WHITESPACE( )
                    ASSIGN(=)
                        WHITESPACE( )
                    TABLEDEF
                        OPENCURLY({)
                            WHITESPACE( )
                        VARARGS(...)
                        CLOSECURLY(})
                RETURN(return)
                    WHITESPACE(\n\n        )
                    COMMENT(---@param parse Parse)
                    WHITESPACE(\n        )
                ANON_FUNCTIONDEF
                    FUNCTION(function)
                        WHITESPACE( )
                    FUNCTIONDEF_PARAMS
                        OPENBRACKET(()
                        IDENTIFIER(parse)
                        CLOSEBRACKET())
                    GLOBAL_ASSIGNMENT
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n            )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(branch)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n\n            )
                        BOOLCHAIN
                            NOT(not)
                                WHITESPACE( )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(match)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(table)
                                        DOTACCESS(.)
                                        IDENTIFIER(unpack)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(args)
                                            CLOSEBRACKET())
                                    CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                            DOTACCESS(.)
                                            IDENTIFIER(Statement)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Failed to terminate body")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    RETURN(return)
                        WHITESPACE(\n\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                SEMICOLON(;)
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(IfStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(IF_STATEMENT)
                            CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isReturnableScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IF)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE( \n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(Expression)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(THEN)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n            \n            )
                            COMMENT(-- statements, if any - may be empty)
                            WHITESPACE(\n            )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(genBody)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(ELSEIF)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(ELSE)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(END)
                                    CLOSEBRACKET())
                            CLOSEBRACKET())
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n\n            )
                            COMMENT(-- potential for elseifs (if they exist, must be well structured or return false "badly made thingmy"))
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(ELSEIF)
                                CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                PARENTHESIS
                                    OPENBRACKET(()
                                        WHITESPACE( )
                                    ANDCHAIN
                                        EXPCHAIN
                                            IDENTIFIER(parse)
                                            COLONACCESS(:)
                                            IDENTIFIER(tryConsume)
                                            FUNCTIONCALL
                                                OPENBRACKET(()
                                                EXPCHAIN
                                                    IDENTIFIER(LBExpressions)
                                                    DOTACCESS(.)
                                                    IDENTIFIER(Expression)
                                                CLOSEBRACKET())
                                        AND(and)
                                            WHITESPACE(\n                    )
                                        EXPCHAIN
                                            IDENTIFIER(parse)
                                                WHITESPACE( )
                                            COLONACCESS(:)
                                            IDENTIFIER(tryConsume)
                                            FUNCTIONCALL
                                                OPENBRACKET(()
                                                EXPCHAIN
                                                    IDENTIFIER(T)
                                                    DOTACCESS(.)
                                                    IDENTIFIER(THEN)
                                                CLOSEBRACKET())
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Improperly specified elseif statement")
                                    CLOSEBRACKET())
                            ELSE(else)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                    )
                                    COMMENT(-- parse statements in the "elseif" section)
                                    WHITESPACE(\n                    )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                        DOTACCESS(.)
                                        IDENTIFIER(genBody)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                DOTACCESS(.)
                                                IDENTIFIER(ELSEIF)
                                            COMMA(,)
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                    WHITESPACE( )
                                                DOTACCESS(.)
                                                IDENTIFIER(ELSE)
                                            COMMA(,)
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                    WHITESPACE( )
                                                DOTACCESS(.)
                                                IDENTIFIER(END)
                                            CLOSEBRACKET())
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                            COMMENT(-- possible "else" section)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(ELSE)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n                )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(genBody)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(END)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(END)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid if Statement")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GlobalAssignmentStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(GLOBAL_ASSIGNMENT)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(ExpressionChainedOperator)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    LOCAL_ASSIGNMENT
                        LOCAL(local)
                            WHITESPACE( \n            )
                            COMMENT(-- check last part of the EXPCHAIN was assignable)
                            WHITESPACE(\n            )
                        IDENTIFIER(lastSymbol)
                            WHITESPACE( )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(symbol)
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                NUMCHAIN
                                    MATHOP_UNARY(#)
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                        DOTACCESS(.)
                                        IDENTIFIER(symbol)
                                CLOSESQUARE(])
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n            )
                        BOOLCHAIN
                            NOT(not)
                                WHITESPACE( )
                            EXPCHAIN
                                IDENTIFIER(is)
                                    WHITESPACE( )
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(lastSymbol)
                                        DOTACCESS(.)
                                        IDENTIFIER(type)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(IDENTIFIER)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(S)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(SQUARE_BRACKETS)
                                    CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE(\n                )
                            COLONACCESS(:)
                            IDENTIFIER(error)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                STRINGCONCAT
                                    STRING("Cannot assign to type: ")
                                    STRINGOP(..)
                                        WHITESPACE( )
                                    EXPCHAIN
                                        IDENTIFIER(lastSymbol)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(type)
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE(\n\n            )
                            COMMENT(-- now check repeatedly for the same, with comma separators)
                            WHITESPACE(\n            )
                            COMMENT(--   return false if a comma is provided, but not a valid assignable value)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(COMMA)
                                CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                            DOTACCESS(.)
                                            IDENTIFIER(LValue)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected lvalue after comma")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(ASSIGN)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE( )
                                COMMENT(-- equals sign "=")
                                WHITESPACE(\n                )
                                COMMENT(-- expect a list of expressions to assign)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                        DOTACCESS(.)
                                        IDENTIFIER(ExpressionList)
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(commit)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    CLOSEBRACKET())
                            ELSE(else)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                    )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected expression following '=' assignment.")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid Assignment/Local Declaration")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(LocalAssignmentStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(LOCAL_ASSIGNMENT)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(LOCAL)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    WHILE_LOOP
                        WHILE(while)
                            WHITESPACE( )
                            COMMENT(-- check last part of the EXPCHAIN was assignable)
                            WHITESPACE(\n            \n            )
                            COMMENT(-- now check repeatedly for the same, with comma separators)
                            WHITESPACE(\n            )
                            COMMENT(--   return false if a comma is provided, but not a valid assignable value)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(COMMA)
                                CLOSEBRACKET())
                        DO(do)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n                )
                            BOOLCHAIN
                                NOT(not)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(IDENTIFIER)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected lvalue after comma")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(ASSIGN)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE( )
                                COMMENT(-- equals sign "=")
                                WHITESPACE(\n                )
                                COMMENT(-- expect a list of expressions to assign)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                        DOTACCESS(.)
                                        IDENTIFIER(ExpressionList)
                                    CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(commit)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    CLOSEBRACKET())
                            ELSE(else)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE(\n                    )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Expected expression following '=' assignment.")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        ELSE(else)
                            WHITESPACE(\n            )
                        RETURN(return)
                            WHITESPACE(\n                )
                            COMMENT(-- local statement can be without an assignment)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        \n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid Assignment/Local Declaration")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(LValue)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE( )
                        COMMENT(-- no typename; meaning it will simplify out)
                        WHITESPACE(\n\n        )
                        COMMENT(-- messy but easier way to handle Lvalues: (saves a lot of duplication))
                        WHITESPACE(\n        )
                        COMMENT(-- easiest thing to do is, check if we can make a valid ExpChain and then make sure the end of it is actually modifiable)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(ExpressionChainedOperator)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    LOCAL_ASSIGNMENT
                        LOCAL(local)
                            WHITESPACE(\n            )
                        IDENTIFIER(lastChild)
                            WHITESPACE( )
                        ASSIGN(=)
                            WHITESPACE( )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            DOTACCESS(.)
                            IDENTIFIER(symbol)
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                NUMCHAIN
                                    MATHOP_UNARY(#)
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                        DOTACCESS(.)
                                        IDENTIFIER(symbol)
                                CLOSESQUARE(])
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n            )
                        ANDCHAIN
                            EXPCHAIN
                                IDENTIFIER(lastChild)
                                    WHITESPACE( )
                            AND(and)
                                WHITESPACE(\n            )
                            EXPCHAIN
                                IDENTIFIER(lastChild)
                                    WHITESPACE( )
                                SQUARE_BRACKETS
                                    OPENSQUARE([)
                                    NUMCHAIN
                                        MATHOP_UNARY(#)
                                        EXPCHAIN
                                            IDENTIFIER(lastChild)
                                    CLOSESQUARE(])
                            AND(and)
                                WHITESPACE(\n            )
                            EXPCHAIN
                                IDENTIFIER(is)
                                    WHITESPACE( )
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(lastChild)
                                        SQUARE_BRACKETS
                                            OPENSQUARE([)
                                            NUMCHAIN
                                                MATHOP_UNARY(#)
                                                EXPCHAIN
                                                    IDENTIFIER(lastChild)
                                            CLOSESQUARE(])
                                        DOTACCESS(.)
                                        IDENTIFIER(type)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(S)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(SQUARE_BRACKETS)
                                    COMMA(,)
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                            WHITESPACE( )
                                        DOTACCESS(.)
                                        IDENTIFIER(IDENTIFIER)
                                    CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid lvalue")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(FunctionCallParenthesis)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(FUNCTIONCALL)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE( )
                        COMMENT(-- remember the parenthesis ARE the actual "function call")
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(  )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(OPENBRACKET)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n\n            )
                            COMMENT(-- can be empty parens)
                            WHITESPACE(\n            )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(ExpressionList)
                            CLOSEBRACKET())
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(CLOSEBRACKET)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    ELSEIF(elseif)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(STRING)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                        COMMENT(-- alternate way to call functions, abyssmal addition to the language )
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    ELSEIF(elseif)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                DOTACCESS(.)
                                IDENTIFIER(TableDef)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                        COMMENT(-- equally mental way of calling functions, please refrain from this)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid function call parenthesis")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(TableAssignment)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(GLOBAL_ASSIGNMENT)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ORCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(SquareBracketsIndex)
                                CLOSEBRACKET())
                        OR(or)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n\n            )
                        ANDCHAIN
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(ASSIGN)
                                    CLOSEBRACKET())
                            AND(and)
                                WHITESPACE( \n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                        DOTACCESS(.)
                                        IDENTIFIER(Expression)
                                    CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        RETURN(return)
                            WHITESPACE(\n\n                )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(commit)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                CLOSEBRACKET())
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid table assignment")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(TableValueInitialization)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                    WHITESPACE(\n            )
                                DOTACCESS(.)
                                IDENTIFIER(TableAssignment)
                            COMMA(,)
                            EXPCHAIN
                                IDENTIFIER(LBExpressions)
                                    WHITESPACE(\n            )
                                DOTACCESS(.)
                                IDENTIFIER(Expression)
                            CLOSEBRACKET())
                                WHITESPACE(\n        )
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid table value")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ForLoopStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(FOR_LOOP)
                            CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isLoopScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isReturnableScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        \n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(FOR)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n            )
                            COMMENT(-- a,b,c,d,e=1..works)
                            WHITESPACE(\n            )
                        ANDCHAIN
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(IDENTIFIER)
                                    CLOSEBRACKET())
                            AND(and)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(ASSIGN)
                                    CLOSEBRACKET())
                            AND(and)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                        DOTACCESS(.)
                                        IDENTIFIER(Expression)
                                    CLOSEBRACKET())
                            AND(and)
                                WHITESPACE( \n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(COMMA)
                                    CLOSEBRACKET())
                            AND(and)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(LBExpressions)
                                        DOTACCESS(.)
                                        IDENTIFIER(Expression)
                                    CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n\n                )
                                COMMENT(-- optional 3rd parameter (step))
                                WHITESPACE(\n                )
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(COMMA)
                                        CLOSEBRACKET())
                                AND(and)
                                    WHITESPACE(\n                    )
                                BOOLCHAIN
                                    NOT(not)
                                        WHITESPACE( )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(LBExpressions)
                                                DOTACCESS(.)
                                                IDENTIFIER(Expression)
                                            CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(error)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    STRING("Trailing ',' in for-loop definition")
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n\n                )
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(DO)
                                        CLOSEBRACKET())
                                AND(and)
                                    WHITESPACE(\n                )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                            DOTACCESS(.)
                                            IDENTIFIER(genBody)
                                            FUNCTIONCALL
                                                OPENBRACKET(()
                                                EXPCHAIN
                                                    IDENTIFIER(T)
                                                    DOTACCESS(.)
                                                    IDENTIFIER(END)
                                                CLOSEBRACKET())
                                        CLOSEBRACKET())
                                AND(and)
                                    WHITESPACE(\n                )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(END)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            RETURN(return)
                                WHITESPACE(\n                    )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(commit)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    CLOSEBRACKET())
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid for-loop")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ForInLoopStatement)
                WHITESPACE(\n\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(FOR_LOOP)
                            CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isLoopScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isReturnableScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        \n        )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(tryConsume)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(T)
                                DOTACCESS(.)
                                IDENTIFIER(FOR)
                            CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    IF_STATEMENT
                        IF(if)
                            WHITESPACE(\n            )
                            COMMENT(-- a,b,c,d,e=1..works)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                        THEN(then)
                            WHITESPACE( )
                        WHILE_LOOP
                            WHILE(while)
                                WHITESPACE( )
                                COMMENT(-- check last part of the EXPCHAIN was assignable)
                                WHITESPACE(\n\n                )
                                COMMENT(-- now check repeatedly for the same, with comma separators)
                                WHITESPACE(\n                )
                                COMMENT(--   return false if a comma is provided, but not a valid assignable value)
                                WHITESPACE(\n                )
                            EXPCHAIN
                                IDENTIFIER(parse)
                                    WHITESPACE( )
                                COLONACCESS(:)
                                IDENTIFIER(tryConsume)
                                FUNCTIONCALL
                                    OPENBRACKET(()
                                    EXPCHAIN
                                        IDENTIFIER(T)
                                        DOTACCESS(.)
                                        IDENTIFIER(COMMA)
                                    CLOSEBRACKET())
                            DO(do)
                                WHITESPACE( )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n                    )
                                BOOLCHAIN
                                    NOT(not)
                                        WHITESPACE( )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                DOTACCESS(.)
                                                IDENTIFIER(IDENTIFIER)
                                            CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                RETURN(return)
                                    WHITESPACE(\n                        )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(error)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        STRING("Expected identifier after comma")
                                        CLOSEBRACKET())
                                END(end)
                                    WHITESPACE(\n                    )
                            END(end)
                                WHITESPACE(\n                )
                        IF_STATEMENT
                            IF(if)
                                WHITESPACE(\n\n                )
                                COMMENT(-- =exp, exp)
                                WHITESPACE(\n                )
                            ANDCHAIN
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(IN)
                                        CLOSEBRACKET())
                                AND(and)
                                    WHITESPACE(\n                )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(LBExpressions)
                                            DOTACCESS(.)
                                            IDENTIFIER(Expression)
                                        CLOSEBRACKET())
                            THEN(then)
                                WHITESPACE( )
                            WHILE_LOOP
                                WHILE(while)
                                    WHITESPACE(\n\n                    )
                                    COMMENT(-- can now handle as many additional params as wanted)
                                    WHITESPACE(\n                    )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(tryConsume)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(COMMA)
                                        CLOSEBRACKET())
                                DO(do)
                                    WHITESPACE( )
                                IF_STATEMENT
                                    IF(if)
                                        WHITESPACE(\n                        )
                                    BOOLCHAIN
                                        NOT(not)
                                            WHITESPACE( )
                                        EXPCHAIN
                                            IDENTIFIER(parse)
                                                WHITESPACE( )
                                            COLONACCESS(:)
                                            IDENTIFIER(tryConsume)
                                            FUNCTIONCALL
                                                OPENBRACKET(()
                                                EXPCHAIN
                                                    IDENTIFIER(LBExpressions)
                                                    DOTACCESS(.)
                                                    IDENTIFIER(Expression)
                                                CLOSEBRACKET())
                                    THEN(then)
                                        WHITESPACE( )
                                    RETURN(return)
                                        WHITESPACE(\n                            )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(error)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            STRING("Trailing ',' in for-loop definition")
                                            CLOSEBRACKET())
                                    END(end)
                                        WHITESPACE(\n                        )
                                END(end)
                                    WHITESPACE(\n                    )
                            IF_STATEMENT
                                IF(if)
                                    WHITESPACE(\n\n                    )
                                ANDCHAIN
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                DOTACCESS(.)
                                                IDENTIFIER(DO)
                                            CLOSEBRACKET())
                                    AND(and)
                                        WHITESPACE(\n                    )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(LBExpressions)
                                                DOTACCESS(.)
                                                IDENTIFIER(genBody)
                                                FUNCTIONCALL
                                                    OPENBRACKET(()
                                                    EXPCHAIN
                                                        IDENTIFIER(T)
                                                        DOTACCESS(.)
                                                        IDENTIFIER(END)
                                                    CLOSEBRACKET())
                                            CLOSEBRACKET())
                                    AND(and)
                                        WHITESPACE(\n                    )
                                    EXPCHAIN
                                        IDENTIFIER(parse)
                                            WHITESPACE( )
                                        COLONACCESS(:)
                                        IDENTIFIER(tryConsume)
                                        FUNCTIONCALL
                                            OPENBRACKET(()
                                            EXPCHAIN
                                                IDENTIFIER(T)
                                                DOTACCESS(.)
                                                IDENTIFIER(END)
                                            CLOSEBRACKET())
                                THEN(then)
                                    WHITESPACE( )
                                RETURN(return)
                                    WHITESPACE(\n                        )
                                EXPCHAIN
                                    IDENTIFIER(parse)
                                        WHITESPACE( )
                                    COLONACCESS(:)
                                    IDENTIFIER(commit)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        CLOSEBRACKET())
                                END(end)
                                    WHITESPACE(\n                    )
                            END(end)
                                WHITESPACE(\n                )
                        END(end)
                            WHITESPACE(\n            )
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid for-loop")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(WhileLoopStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(WHILE_LOOP)
                            CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isLoopScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isReturnableScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        \n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(WHILE)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(Expression)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(DO)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(genBody)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(END)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(END)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid while loop")
                        CLOSEBRACKET())
                SEMICOLON(;)
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(RepeatUntilStatement)
                WHITESPACE(\n\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(REPEAT_UNTIL)
                            CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isLoopScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isReturnableScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        \n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(REPEAT)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(genBody)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(UNTIL)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(UNTIL)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(Expression)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid repeat-until loop")
                        CLOSEBRACKET())
                SEMICOLON(;)
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(DoEndStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(DO_END)
                            CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                        DOTACCESS(.)
                        IDENTIFIER(isReturnableScope)
                    ASSIGN(=)
                        WHITESPACE( )
                    TRUE(true)
                        WHITESPACE( )
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(DO)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(genBody)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(END)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(END)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid repeat-until loop")
                        CLOSEBRACKET())
                SEMICOLON(;)
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GotoStatement)
                WHITESPACE(\n\n    )
                COMMENT(-- could arguably ban this)
                WHITESPACE(\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(GOTOSTATEMENT)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(GOTO)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid goto")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(GotoLabelStatement)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(GOTOLABEL)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(GOTOMARKER)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(IDENTIFIER)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n            )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(GOTOMARKER)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n                )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid goto ::label::")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        GLOBAL_ASSIGNMENT
            IDENTIFIER(ProcessorLBTagSection)
                WHITESPACE(\n\n    )
                COMMENT(---@param parse Parse)
                WHITESPACE(\n    )
            ASSIGN(=)
                WHITESPACE( )
            ANON_FUNCTIONDEF
                FUNCTION(function)
                    WHITESPACE( )
                FUNCTIONDEF_PARAMS
                    OPENBRACKET(()
                    IDENTIFIER(parse)
                    CLOSEBRACKET())
                GLOBAL_ASSIGNMENT
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE(\n        )
                    ASSIGN(=)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(branch)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            EXPCHAIN
                                IDENTIFIER(S)
                                DOTACCESS(.)
                                IDENTIFIER(LBTAG_SECTION)
                            CLOSEBRACKET())
                IF_STATEMENT
                    IF(if)
                        WHITESPACE(\n        )
                    ANDCHAIN
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(LBTAG_START)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE( \n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(FunctionCallParenthesis)
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(LBExpressions)
                                    DOTACCESS(.)
                                    IDENTIFIER(genBody)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        EXPCHAIN
                                            IDENTIFIER(T)
                                            DOTACCESS(.)
                                            IDENTIFIER(LBTAG_END)
                                        CLOSEBRACKET())
                                CLOSEBRACKET())
                        AND(and)
                            WHITESPACE(\n        )
                        EXPCHAIN
                            IDENTIFIER(parse)
                                WHITESPACE( )
                            COLONACCESS(:)
                            IDENTIFIER(tryConsume)
                            FUNCTIONCALL
                                OPENBRACKET(()
                                EXPCHAIN
                                    IDENTIFIER(T)
                                    DOTACCESS(.)
                                    IDENTIFIER(LBTAG_END)
                                CLOSEBRACKET())
                    THEN(then)
                        WHITESPACE( )
                    RETURN(return)
                        WHITESPACE(\n            )
                    EXPCHAIN
                        IDENTIFIER(parse)
                            WHITESPACE( )
                        COLONACCESS(:)
                        IDENTIFIER(commit)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    END(end)
                        WHITESPACE(\n        )
                RETURN(return)
                    WHITESPACE(\n\n        )
                EXPCHAIN
                    IDENTIFIER(parse)
                        WHITESPACE( )
                    COLONACCESS(:)
                    IDENTIFIER(error)
                    FUNCTIONCALL
                        OPENBRACKET(()
                        STRING("Invalid lb tag setup")
                        CLOSEBRACKET())
                END(end)
                    WHITESPACE(\n    )
        SEMICOLON(;)
        CLOSECURLY(})
            WHITESPACE(\n)
GLOBAL_ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(toString)
            WHITESPACE(\n\n)
    ASSIGN(=)
        WHITESPACE( )
    ANON_FUNCTIONDEF
        FUNCTION(function)
            WHITESPACE( )
        FUNCTIONDEF_PARAMS
            OPENBRACKET(()
            IDENTIFIER(tree)
            CLOSEBRACKET())
        LOCAL_ASSIGNMENT
            LOCAL(local)
                WHITESPACE(\n    )
            IDENTIFIER(result)
                WHITESPACE( )
            ASSIGN(=)
                WHITESPACE( )
            TABLEDEF
                OPENCURLY({)
                    WHITESPACE( )
                CLOSECURLY(})
        FOR_LOOP
            FOR(for)
                WHITESPACE(\n    )
            IDENTIFIER(i)
                WHITESPACE( )
            ASSIGN(=)
            NUMBER(1)
            COMMA(,)
            NUMCHAIN
                MATHOP_UNARY(#)
                EXPCHAIN
                    IDENTIFIER(tree)
            DO(do)
                WHITESPACE( )
            GLOBAL_ASSIGNMENT
                EXPCHAIN
                    IDENTIFIER(result)
                        WHITESPACE(\n        )
                    SQUARE_BRACKETS
                        OPENSQUARE([)
                        NUMCHAIN
                            NUMCHAIN
                                MATHOP_UNARY(#)
                                EXPCHAIN
                                    IDENTIFIER(result)
                            MATHOP(+)
                            NUMBER(1)
                        CLOSESQUARE(])
                ASSIGN(=)
                    WHITESPACE( )
                EXPCHAIN
                    IDENTIFIER(toString)
                        WHITESPACE( )
                    FUNCTIONCALL
                        OPENBRACKET(()
                        EXPCHAIN
                            IDENTIFIER(tree)
                            SQUARE_BRACKETS
                                OPENSQUARE([)
                                EXPCHAIN
                                    IDENTIFIER(i)
                                CLOSESQUARE(])
                        CLOSEBRACKET())
            GLOBAL_ASSIGNMENT
                EXPCHAIN
                    IDENTIFIER(result)
                        WHITESPACE(\n        )
                    SQUARE_BRACKETS
                        OPENSQUARE([)
                        NUMCHAIN
                            NUMCHAIN
                                MATHOP_UNARY(#)
                                EXPCHAIN
                                    IDENTIFIER(result)
                            MATHOP(+)
                            NUMBER(1)
                        CLOSESQUARE(])
                ASSIGN(=)
                    WHITESPACE( )
                EXPCHAIN
                    IDENTIFIER(tree)
                        WHITESPACE( )
                    SQUARE_BRACKETS
                        OPENSQUARE([)
                        EXPCHAIN
                            IDENTIFIER(i)
                        CLOSESQUARE(])
                    DOTACCESS(.)
                    IDENTIFIER(raw)
            END(end)
                WHITESPACE(\n    )
        RETURN(return)
            WHITESPACE(\n    )
        EXPCHAIN
            IDENTIFIER(table)
                WHITESPACE( )
            DOTACCESS(.)
            IDENTIFIER(concat)
            FUNCTIONCALL
                OPENBRACKET(()
                EXPCHAIN
                    IDENTIFIER(result)
                CLOSEBRACKET())
        END(end)
            WHITESPACE(\n)
SEMICOLON(;)
LOCAL_ASSIGNMENT
    LOCAL(local)
        WHITESPACE(\n\n)
    IDENTIFIER(s)
        WHITESPACE( )
    ASSIGN(=)
        WHITESPACE( )
    EXPCHAIN
        IDENTIFIER(require)
            WHITESPACE( )
        FUNCTIONCALL
            OPENBRACKET(()
            STRING("socket")
            CLOSEBRACKET())
GLOBAL_ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(parse)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE( )
    ANON_FUNCTIONDEF
        FUNCTION(function)
            WHITESPACE( )
        FUNCTIONDEF_PARAMS
            OPENBRACKET(()
            IDENTIFIER(text)
            CLOSEBRACKET())
        LOCAL_ASSIGNMENT
            LOCAL(local)
                WHITESPACE(\n    )
            IDENTIFIER(startTime)
                WHITESPACE( )
            ASSIGN(=)
                WHITESPACE( )
            EXPCHAIN
                IDENTIFIER(s)
                    WHITESPACE( )
                DOTACCESS(.)
                IDENTIFIER(gettime)
                FUNCTIONCALL
                    OPENBRACKET(()
                    CLOSEBRACKET())
        LOCAL_ASSIGNMENT
            LOCAL(local)
                WHITESPACE(\n    )
            IDENTIFIER(tokens)
                WHITESPACE( )
            ASSIGN(=)
                WHITESPACE( )
            EXPCHAIN
                IDENTIFIER(tokenize)
                    WHITESPACE( )
                FUNCTIONCALL
                    OPENBRACKET(()
                    EXPCHAIN
                        IDENTIFIER(text)
                    CLOSEBRACKET())
        EXPCHAIN
            IDENTIFIER(print)
                WHITESPACE(\n\n    )
            FUNCTIONCALL
                OPENBRACKET(()
                STRINGCONCAT
                    STRING("tokenize time: ")
                    STRINGOP(..)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(tostring)
                            WHITESPACE( )
                        FUNCTIONCALL
                            OPENBRACKET(()
                            NUMCHAIN
                                EXPCHAIN
                                    IDENTIFIER(s)
                                    DOTACCESS(.)
                                    IDENTIFIER(gettime)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        CLOSEBRACKET())
                                MATHOP(-)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(startTime)
                                        WHITESPACE( )
                            CLOSEBRACKET())
                CLOSEBRACKET())
        GLOBAL_ASSIGNMENT
            EXPCHAIN
                IDENTIFIER(startTime)
                    WHITESPACE( )
                    COMMENT(-- 2.3634777069092 (improved))
                    WHITESPACE(\n\n    )
            ASSIGN(=)
                WHITESPACE( )
            EXPCHAIN
                IDENTIFIER(s)
                    WHITESPACE( )
                DOTACCESS(.)
                IDENTIFIER(gettime)
                FUNCTIONCALL
                    OPENBRACKET(()
                    CLOSEBRACKET())
        LOCAL_ASSIGNMENT
            LOCAL(local)
                WHITESPACE(\n    )
            IDENTIFIER(parser)
                WHITESPACE( )
            ASSIGN(=)
                WHITESPACE( )
            EXPCHAIN
                IDENTIFIER(Parse)
                    WHITESPACE( )
                COLONACCESS(:)
                IDENTIFIER(new)
                FUNCTIONCALL
                    OPENBRACKET(()
                    NIL(nil)
                    COMMA(,)
                    EXPCHAIN
                        IDENTIFIER(tokens)
                            WHITESPACE( )
                    COMMA(,)
                    NUMBER(1)
                        WHITESPACE( )
                    CLOSEBRACKET())
        LOCAL_ASSIGNMENT
            LOCAL(local)
                WHITESPACE(\n    )
            IDENTIFIER(result)
                WHITESPACE( )
            ASSIGN(=)
                WHITESPACE( )
            EXPCHAIN
                IDENTIFIER(LBExpressions)
                    WHITESPACE( )
                DOTACCESS(.)
                IDENTIFIER(Program)
                FUNCTIONCALL
                    OPENBRACKET(()
                    EXPCHAIN
                        IDENTIFIER(parser)
                    CLOSEBRACKET())
        EXPCHAIN
            IDENTIFIER(print)
                WHITESPACE(\n    )
            FUNCTIONCALL
                OPENBRACKET(()
                STRINGCONCAT
                    STRING("parse time: ")
                    STRINGOP(..)
                        WHITESPACE( )
                    EXPCHAIN
                        IDENTIFIER(tostring)
                            WHITESPACE( )
                        FUNCTIONCALL
                            OPENBRACKET(()
                            NUMCHAIN
                                EXPCHAIN
                                    IDENTIFIER(s)
                                    DOTACCESS(.)
                                    IDENTIFIER(gettime)
                                    FUNCTIONCALL
                                        OPENBRACKET(()
                                        CLOSEBRACKET())
                                MATHOP(-)
                                    WHITESPACE( )
                                EXPCHAIN
                                    IDENTIFIER(startTime)
                                        WHITESPACE( )
                            CLOSEBRACKET())
                CLOSEBRACKET())
        IF_STATEMENT
            IF(if)
                WHITESPACE( )
                COMMENT(-- 0.5665168762207 (improved?))
                WHITESPACE(\n\n    )
            BOOLCHAIN
                NOT(not)
                    WHITESPACE( )
                EXPCHAIN
                    IDENTIFIER(result)
                        WHITESPACE( )
            THEN(then)
                WHITESPACE( )
            EXPCHAIN
                IDENTIFIER(error)
                    WHITESPACE(\n        )
                FUNCTIONCALL
                    OPENBRACKET(()
                    EXPCHAIN
                        IDENTIFIER(parser)
                        DOTACCESS(.)
                        IDENTIFIER(errorObj)
                        COLONACCESS(:)
                        IDENTIFIER(toString)
                        FUNCTIONCALL
                            OPENBRACKET(()
                            CLOSEBRACKET())
                    CLOSEBRACKET())
            END(end)
                WHITESPACE(\n    )
        RETURN(return)
            WHITESPACE(\n    \n    )
        EXPCHAIN
            IDENTIFIER(parser)
                WHITESPACE( )
            DOTACCESS(.)
            IDENTIFIER(symbol)
        END(end)
            WHITESPACE(\n)
SEMICOLON(;)
EOF
    WHITESPACE(\n\n\n\n\n)
]]