module App.Services.Click
  ( Store
  , State
  , build
  ) where

-- import Prelude (Unit, unit, (>>=), pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

type Store = { amount :: Int }

type State = S.State Store

build :: forall eff. Eff (st :: St | eff) State
build = S.build { amount: 0 }
