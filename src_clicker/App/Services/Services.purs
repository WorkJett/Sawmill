module App.Services.Services
  ( Store
  , State
  , build
  , services
  , click
  ) where

import Prelude (Unit, unit, pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import App.Services.Click as Click

type Store = { click :: Click.State }

type State = S.State Store

build :: forall eff. Eff (st :: St | eff) Unit
build = do
  clickState <- Click.build
  provider <- S.provider
  _ <- S.set provider
    { click: clickState
    }
  pure unit

services :: forall eff. Eff (st :: St | eff) Store
services = do
  provider::State <- S.provider
  S.get provider

click :: forall eff. Eff (st :: St | eff) Click.State
click = do
  srvs <- services
  pure srvs.click
