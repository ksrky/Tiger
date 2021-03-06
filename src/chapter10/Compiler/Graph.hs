module Compiler.Graph where

import qualified Common.Temp as Temp
import Prelude hiding (pred, succ)

import Control.Monad.State
import Data.List (delete)
import qualified Data.Map.Strict as M
import qualified Data.Vector as V

------------------------------------------------------------------
-- Node
------------------------------------------------------------------
type Node = Int

data Noderep = Node {succ :: [Node], pred :: [Node]} deriving (Eq)

emptyNode :: Noderep
emptyNode = Node{succ = [], pred = []}

bogusNode :: Noderep
bogusNode = Node{succ = [-1], pred = []}

isBogus :: Noderep -> Bool
isBogus Node{succ = (-1 : _)} = True
isBogus _ = False

------------------------------------------------------------------
-- Graph
------------------------------------------------------------------
type Graph = V.Vector Noderep

newGraph :: Graph
newGraph = V.empty

at :: Graph -> Node -> Noderep
at = (V.!)

nodes :: Graph -> [Node]
nodes g = f 0
    where
        f i
                | isBogus (g `at` i) = f (i + 1)
                | otherwise = i : f (i + 1)

succ' :: Node -> State Graph [Node]
succ' i = do
        g <- get
        let Node{succ = s} = g `at` i
        return s

pred' :: Node -> State Graph [Node]
pred' i = do
        g <- get
        let Node{pred = p} = g `at` i
        return p

adj :: Node -> State Graph [Node]
adj gi = (++) <$> pred' gi <*> succ' gi

next :: Node -> State Graph [Node]
next i = do
        g <- get
        return $ [i + 1 | i /= (V.length g - 1)]

update :: Node -> Noderep -> State Graph ()
update i e = modify $ flip (V.//) [(i, e)]

newNode :: State Graph Node
newNode = do
        g <- get
        look g 0 (length g)
    where
        look :: Graph -> Node -> Node -> State Graph Node
        look g lo hi
                | lo == hi = do
                        put (V.snoc g emptyNode)
                        return lo
                | isBogus (g `at` m) = look g lo m
                | otherwise = look g (m + 1) hi
            where
                m = (lo + hi) `div` 2

diddleEdge :: (Node -> [Node] -> [Node]) -> Node -> Node -> State Graph ()
diddleEdge change i j = do
        g <- get
        let ni = g `at` i
            nj = g `at` j
        update i ni{succ = change j (succ ni)}
        update j nj{pred = change i (succ nj)}

mkEdge :: Node -> Node -> State Graph ()
mkEdge = diddleEdge (:)

rmEdge :: Node -> Node -> State Graph ()
rmEdge = diddleEdge Data.List.delete

------------------------------------------------------------------
-- Table
------------------------------------------------------------------
type Table a = M.Map Node a

newTable :: Table a
newTable = M.empty

enter :: Table a -> Node -> a -> Table a
enter table n v = M.insert n v table

(!?) :: Table a -> Node -> a
table !? n = case table M.!? n of
        Just v -> v
        Nothing -> error "Graph.Table index out of range"
