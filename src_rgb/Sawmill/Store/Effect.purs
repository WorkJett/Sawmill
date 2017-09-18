module Sawmill.Store.Effect
  ( St
  ) where

import Control.Monad.Eff

foreign import data St :: Effect
