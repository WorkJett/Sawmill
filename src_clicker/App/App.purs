module App.App
  ( init
  ) where

import Prelude (Unit, unit, (>>=), pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Services.Services as Srv
import App.Views.AmountForm (form)

init :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
init = do
  _ <- Srv.build
  body <- D.body
  _ <- form >>= D.append body
  pure unit
