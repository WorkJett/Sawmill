module Sawmill.DOM.Location
  ( pathname
  ) where

-- import Prelude
import Control.Monad.Eff (Eff)

import Sawmill.DOM.Effect (DOM)

foreign import pathname :: forall eff. Eff (dom :: DOM | eff) String
