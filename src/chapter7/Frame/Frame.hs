module Frame.Frame where

import qualified Common.Temp as Temp
import qualified IR.Tree as T

import Control.Monad.State

data Access = InFrame Int | InReg Temp.Temp deriving (Eq, Show)

class FrameBase f where
        newFrame :: Temp.Label -> [Bool] -> State Temp.TempState f
        name :: f -> Temp.Label
        formals :: f -> [Access]
        locals :: f -> [Access]
        allocLocal :: f -> Bool -> State Temp.TempState f
        fp :: f -> Temp.Temp
        rv :: f -> Temp.Temp

data Frag f
        = PROC {body :: T.Stm, frame :: f}
        | STRING Temp.Label String
        deriving (Eq, Show)

wordSize :: T.Exp
wordSize = T.CONST 32

exp :: Access -> T.Exp -> T.Exp
exp (InFrame k) e = T.MEM (T.BINOP T.PLUS e (T.CONST k))
exp (InReg t) _ = T.TEMP t

externalCall :: String -> [T.Exp] -> T.Exp
externalCall s = T.CALL (T.NAME $ Temp.namedLabel s)

procEntryExit1 :: FrameBase f => (f, T.Stm) -> T.Stm
procEntryExit1 (frame, body) = body
