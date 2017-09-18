module App.Views.Modals
  ( modals
  ) where

import Prelude ((>>=), bind, Unit, unit, (==), pure)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.BEM as BEM

import App.Services.Router as Router
import App.Controls.SimpleForm (simpleForm)

bModal :: String
bModal = BEM.b "test-modal"
mModalShow :: String
mModalShow = BEM.m bModal "show"

modals :: forall eff. D.Element -> Eff (st :: St, dom :: DOM | eff) Unit
modals container = do
  modalEl <- D.div >>= D.klass mModalShow
  _ <- simpleForm modalEl
  router <- Router.router
  _ <- S.behavior router \route -> if route.route == "modals"
    then do
      _ <- D.append container modalEl
      pure unit
    else do
      _ <- D.remove modalEl
      pure unit
  pure unit
