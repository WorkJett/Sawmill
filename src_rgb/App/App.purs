module App.App
  ( init
  ) where

import Prelude (Unit, unit, pure, bind, (==))
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Services.Services as Srv
import App.Services.Router as Router

import App.Controls.Top (top)
import App.Views.Red (red)
import App.Views.Green (green)
import App.Views.Blue (blue)

init :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
init = do
  _ <- Srv.build
  _ <- Router.parse
  _ <- Router.urlHandle
  router <- Router.router
  _ <- S.behavior router "appRoutingHandler" \route -> if route.route == ""
    then do
      _ <- Router.toRed
      pure unit
    else do
      pure unit
  body <- D.body
  _ <- top body
  _ <- red body
  _ <- green body
  _ <- blue body
  pure unit
