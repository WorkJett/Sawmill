module App.Services.Services
  ( ServicesState
  , build
  , services
  ) where

import Prelude (Unit, unit, pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

type ServicesState = S.State { router :: S.State { route :: String } }

build :: forall eff. Eff (st :: St | eff) Unit
build = do
  routerState <- S.build { route: "" }
  provider <- S.provider
  _ <- S.set provider { router: routerState }
  pure unit

services :: forall eff. Eff (st :: St | eff) { router :: S.State { route :: String } }
services = do
  provider::ServicesState <- S.provider
  S.get provider
