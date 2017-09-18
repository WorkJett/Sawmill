module App.App
  ( init
  ) where

import Prelude (Unit, unit, pure, bind, (==), (>>=))
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Services.Services as Srv
import App.Services.Router as Router

import App.Views.Modals (modals)
import App.Views.Buttons (buttons)

init :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
init = do
  _ <- Srv.build
  _ <- Router.parse
  _ <- Router.urlHandle
  router <- Router.router
  _ <- S.behavior router \route -> if route.route == ""
    then do
      _ <- Router.toModals
      pure unit
    else do
      pure unit
  body <- D.body
  rootEl <- D.div >>= D.klass "root" >>= D.append body
  _ <- modals body
  _ <- buttons body
  pure unit
