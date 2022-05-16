module Compiler.Flow where

import qualified Common.Temp as Temp
import qualified Compiler.Graph as G

data FlowGraph = FGraph
        { control :: G.Graph
        , def :: G.Table [Temp.Temp]
        , use :: G.Table [Temp.Temp]
        , ismove :: G.Table Bool
        }

newFlowGraph :: FlowGraph
newFlowGraph = FGraph G.newGraph G.newTable G.newTable G.newTable
