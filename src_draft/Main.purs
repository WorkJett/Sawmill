module Main where

import Prelude (Unit, unit, (>>=), pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.DOM.Effect (DOM)
import Sawmill.Store.Effect (St)

import App.App

main :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
main = do
  _ <- init
  pure unit
