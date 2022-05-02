a=[[
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(a)
            COMMENT(-- Author: Nameous Changey)
            WHITESPACE(\n)
            COMMENT(-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension)
            WHITESPACE(\n)
            COMMENT(-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090)
            WHITESPACE(\n)
            COMMENT(--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension))
            WHITESPACE(\n)
            COMMENT(--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey)
            WHITESPACE(\n)
            COMMENT(------------------------------------------------------------------------------------------------------------------------------------------------------------)
            WHITESPACE(\n\n)
    ASSIGN(=)
        WHITESPACE( )
    HEX(0x123)
        WHITESPACE( )
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(a)
            WHITESPACE(\n\n)
    ASSIGN(=)
        WHITESPACE( )
    PARENTHESIS
        OPENBRACKET(()
            WHITESPACE( )
        PARENTHESIS
            OPENBRACKET(()
            PARENTHESIS
                OPENBRACKET(()
                PARENTHESIS
                    OPENBRACKET(()
                    OPERATORCHAIN
                        NUMBER(1)
                        BINARY_OP(+)
                            WHITESPACE( )
                        NUMBER(2)
                            WHITESPACE( )
                    CLOSEBRACKET())
                CLOSEBRACKET())
            CLOSEBRACKET())
        CLOSEBRACKET())
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(d)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE( )
    OPERATORCHAIN
        NUMBER(1)
            WHITESPACE( )
        BINARY_OP(+)
            WHITESPACE( )
        NUMBER(2)
            WHITESPACE( )
        BINARY_OP(+)
            WHITESPACE( )
        NUMBER(3)
            WHITESPACE( )
        BINARY_OP(+)
            WHITESPACE( )
        MIXED_OP(-)
            WHITESPACE( )
        NUMBER(4)
EXPCHAIN
    IDENTIFIER(require)
        WHITESPACE(\n)
    FUNCTIONCALL
        OPENBRACKET(()
        STRING("LifeBoatAPI")
        CLOSEBRACKET())
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(color_Highlight)
            WHITESPACE(              )
            COMMENT(-- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library)
            WHITESPACE(\n\n)
            COMMENT(-- color palette, keeping them here makes UI easier to restyle)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE( )
    EXPCHAIN
        IDENTIFIER(LifeBoatAPI)
            WHITESPACE( )
        DOTACCESS(.)
        IDENTIFIER(LBColorRGBA)
        COLONACCESS(:)
        IDENTIFIER(lbcolorrgba_newGammaCorrected)
        FUNCTIONCALL
            OPENBRACKET(()
            NUMBER(230)
            COMMA(,)
            NUMBER(230)
                WHITESPACE( )
            COMMA(,)
            NUMBER(230)
                WHITESPACE( )
            CLOSEBRACKET())
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(color_Inactive)
            WHITESPACE(   )
            COMMENT(-- offwhite)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE(  )
    EXPCHAIN
        IDENTIFIER(LifeBoatAPI)
            WHITESPACE( )
        DOTACCESS(.)
        IDENTIFIER(LBColorRGBA)
        COLONACCESS(:)
        IDENTIFIER(lbcolorrgba_newGammaCorrected)
        FUNCTIONCALL
            OPENBRACKET(()
            NUMBER(100)
            COMMA(,)
            NUMBER(100)
            COMMA(,)
            NUMBER(100)
            CLOSEBRACKET())
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(color_Active)
            WHITESPACE(     )
            COMMENT(-- grey)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE(    )
    EXPCHAIN
        IDENTIFIER(LifeBoatAPI)
            WHITESPACE( )
        DOTACCESS(.)
        IDENTIFIER(LBColorRGBA)
        COLONACCESS(:)
        IDENTIFIER(lbcolorrgba_newGammaCorrected)
        FUNCTIONCALL
            OPENBRACKET(()
            NUMBER(230)
            COMMA(,)
            NUMBER(150)
            COMMA(,)
            NUMBER(0)
            CLOSEBRACKET())
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(myButton)
            WHITESPACE(   )
            COMMENT(-- orangeRed)
            WHITESPACE(\n\n)
            COMMENT(-- define out button)
            WHITESPACE(\n)
    ASSIGN(=)
        WHITESPACE( )
    EXPCHAIN
        IDENTIFIER(LifeBoatAPI)
            WHITESPACE( )
        DOTACCESS(.)
        IDENTIFIER(LBTouchScreen)
        COLONACCESS(:)
        IDENTIFIER(lbtouchscreen_newStyledButton)
        FUNCTIONCALL
            OPENBRACKET(()
            NUMBER(0)
            COMMA(,)
            NUMBER(1)
                WHITESPACE( )
            COMMA(,)
            NUMBER(31)
                WHITESPACE( )
            COMMA(,)
            NUMBER(9)
                WHITESPACE( )
            COMMA(,)
            STRING("Toggle")
                WHITESPACE( )
            COMMA(,)
            EXPCHAIN
                IDENTIFIER(color_Highlight)
                    WHITESPACE( )
            COMMA(,)
            EXPCHAIN
                IDENTIFIER(color_Inactive)
                    WHITESPACE( )
            COMMA(,)
            EXPCHAIN
                IDENTIFIER(color_Active)
                    WHITESPACE( )
            COMMA(,)
            EXPCHAIN
                IDENTIFIER(color_Highlight)
                    WHITESPACE( )
            COMMA(,)
            EXPCHAIN
                IDENTIFIER(color_Inactive)
            CLOSEBRACKET())
ASSIGNMENT
    EXPCHAIN
        IDENTIFIER(ticks)
            WHITESPACE( )
            COMMENT(-- using the TouchScreen functionality from LifeBoatAPI - make a simple button)
            WHITESPACE(\n\n)
    ASSIGN(=)
        WHITESPACE( )
    NUMBER(0)
        WHITESPACE( )
NAMEDFUNCTIONDEF
    FUNCTION(function)
        WHITESPACE(\n)
    IDENTIFIER(onTick)
        WHITESPACE( )
    FUNCTIONDEF_PARAMS
        OPENBRACKET(()
        CLOSEBRACKET())
    EXPCHAIN
        IDENTIFIER(LifeBoatAPI)
            WHITESPACE(\n    )
        DOTACCESS(.)
        IDENTIFIER(LBTouchScreen)
        COLONACCESS(:)
        IDENTIFIER(lbtouchscreen_onTick)
        FUNCTIONCALL
            OPENBRACKET(()
            CLOSEBRACKET())
    ASSIGNMENT
        EXPCHAIN
            IDENTIFIER(ticks)
                WHITESPACE( )
                COMMENT(-- touchscreen handler provided by LifeBoatAPI. Handles checking for clicks/releases etc.)
                WHITESPACE(\n    )
        ASSIGN(=)
            WHITESPACE( )
        OPERATORCHAIN
            EXPCHAIN
                IDENTIFIER(ticks)
                    WHITESPACE( )
            BINARY_OP(+)
                WHITESPACE( )
            NUMBER(1)
                WHITESPACE( )
    IF_STATEMENT
        IF(if)
            WHITESPACE(\n\n    )
            COMMENT(-- listen for the button being "clicked and released" (a "true" click like Windows))
            WHITESPACE(\n    )
            COMMENT(--   then toggle the circle drawing color)
            WHITESPACE(\n    )
        IF_CONDITION
            EXPCHAIN
                IDENTIFIER(myButton)
                    WHITESPACE( )
                COLONACCESS(:)
                IDENTIFIER(lbstyledbutton_isReleased)
                FUNCTIONCALL
                    OPENBRACKET(()
                    CLOSEBRACKET())
        THEN(then)
            WHITESPACE( )
        ASSIGNMENT
            EXPCHAIN
                IDENTIFIER(isCircleColorToggled)
                    WHITESPACE(\n        )
            ASSIGN(=)
                WHITESPACE( )
            NOT(not)
                WHITESPACE( )
            EXPCHAIN
                IDENTIFIER(isCircleColorToggled)
                    WHITESPACE( )
        END(end)
            WHITESPACE(    \n    )
    END(end)
        WHITESPACE(\n)
NAMEDFUNCTIONDEF
    FUNCTION(function)
        WHITESPACE(\n\n)
    IDENTIFIER(onDraw)
        WHITESPACE( )
    FUNCTIONDEF_PARAMS
        OPENBRACKET(()
        CLOSEBRACKET())
    IF_STATEMENT
        IF(if)
            WHITESPACE(\n	)
            COMMENT(-- when you simulate (F6), you should see a grey circle growing over 10 seconds and repeating.)
            WHITESPACE(\n    )
            COMMENT(-- Clicking the button, will change between orangeRed and grey)
            WHITESPACE(\n    )
        IF_CONDITION
            EXPCHAIN
                IDENTIFIER(isCircleColorToggled)
                    WHITESPACE( )
        THEN(then)
            WHITESPACE( )
        EXPCHAIN
            IDENTIFIER(color_Active)
                WHITESPACE(\n        )
            COLONACCESS(:)
            IDENTIFIER(lbcolorrgba_setColor)
            FUNCTIONCALL
                OPENBRACKET(()
                CLOSEBRACKET())
        ELSE(else)
            WHITESPACE( )
            COMMENT(-- replacement for screen.setColor)
            WHITESPACE(\n    )
        EXPCHAIN
            IDENTIFIER(color_Inactive)
                WHITESPACE(\n        )
            COLONACCESS(:)
            IDENTIFIER(lbcolorrgba_setColor)
            FUNCTIONCALL
                OPENBRACKET(()
                CLOSEBRACKET())
        END(end)
            WHITESPACE(\n    )
    EXPCHAIN
        IDENTIFIER(screen)
            WHITESPACE(\n	)
        DOTACCESS(.)
        IDENTIFIER(drawCircleF)
        FUNCTIONCALL
            OPENBRACKET(()
            NUMBER(16)
            COMMA(,)
            NUMBER(16)
                WHITESPACE( )
            COMMA(,)
            OPERATORCHAIN
                PARENTHESIS
                    OPENBRACKET(()
                        WHITESPACE( )
                    OPERATORCHAIN
                        EXPCHAIN
                            IDENTIFIER(ticks)
                        BINARY_OP(%)
                        NUMBER(600)
                    CLOSEBRACKET())
                BINARY_OP(/)
                NUMBER(60)
            CLOSEBRACKET())
    EXPCHAIN
        IDENTIFIER(myButton)
            WHITESPACE(\n\n    )
            COMMENT(-- draw our button - using its internal styling (set at the top when we created it))
            WHITESPACE(\n    )
        COLONACCESS(:)
        IDENTIFIER(lbstyledbutton_draw)
        FUNCTIONCALL
            OPENBRACKET(()
            CLOSEBRACKET())
    END(end)
        WHITESPACE( )
        COMMENT(-- this button code is of course just as an example, CTRL+CLICK any function to see how it was written, to write your own better one)
        WHITESPACE(\n)
EOF
]]