module Core.Tree where

import qualified Temp.Temp as Temp

data Exp
        = CONST Int
        | NAME Temp.Label
        | TEMP Temp.Temp
        | BINOP BinOp Exp Exp
        | MEM Exp
        | CALL Exp [Exp]
        | ESEQ Stm Exp
        deriving (Eq, Show)

data Stm
        = MOVE Exp Exp
        | EXP Exp
        | JUMP Exp [Temp.Label]
        | CJUMP Relop Exp Exp Temp.Label Temp.Label
        | SEQ Stm Stm
        | LABEL Temp.Label
        deriving (Eq, Show)

data BinOp
        = PLUS
        | MINUS
        | MUL
        | DIV
        | AND
        | OR
        | LSHIFT
        | RSHIFT
        | ARSHIFT
        | XOR
        deriving (Eq, Show)

data Relop
        = EQ
        | NE
        | LT
        | GT
        | LE
        | GE
        | ULT
        | ULE
        | UGT
        | UGE
        deriving (Eq, Show)