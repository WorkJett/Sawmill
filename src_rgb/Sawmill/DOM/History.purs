module Sawmill.DOM.History
  ( pushState
  ) where

import Prelude (Unit)
import Control.Monad.Eff (Eff)

import Sawmill.DOM.Effect (DOM)

foreign import pushState :: forall eff. String -> String -> Eff (dom :: DOM | eff) Unit
