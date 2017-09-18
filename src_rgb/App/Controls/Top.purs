module App.Controls.Top
  ( top
  ) where

import Prelude ((>>=), bind, Unit, unit, pure)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Services.Router as Router

top :: forall eff. D.Element -> Eff (st :: St, dom :: DOM | eff) Unit
top container = do
  div <- D.div >>= D.klass "top"
  router <- Router.router
  _ <- S.behavior router "topRoutingHandler" \route -> do
    _ <- D.text route.route div
    pure unit
  _ <- D.append container div
  pure unit
