module Common.Temp where

import qualified Common.Symbol as Symbol

import Control.Monad.State (MonadState (state), State)

type Temp = Int
type Label = Symbol.Symbol

data TempState = TS {temps :: Temp, labs :: Int}

emptyState :: TempState
emptyState = TS{temps = 0, labs = 0}

newTemp :: State TempState Temp
newTemp = state (\(TS t l) -> (t, TS (t + 1) l))

makeString :: Int -> String
makeString t = "t" ++ show t

newLabel :: State TempState Label
newLabel = state (\(TS t l) -> ("L" ++ show l, TS t (l + 1)))

namedLabel :: String -> Label
namedLabel = Symbol.symbol
