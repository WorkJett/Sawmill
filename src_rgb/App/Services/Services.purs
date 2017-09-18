module App.Services.Services
  ( Store
  , State
  , build
  , services
  ) where

import Prelude (Unit, unit, pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

type Store = { router :: S.State { route :: String } }
type State = S.State Store

build :: forall eff. Eff (st :: St | eff) Unit
build = do
  routerState <- S.build { route: "" }
  provider <- S.provider
  _ <- S.set provider { router: routerState }
  pure unit

services :: forall eff. Eff (st :: St | eff) Store
services = do
  provider::State <- S.provider
  S.get provider
