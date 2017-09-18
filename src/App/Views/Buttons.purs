module App.Views.Buttons
  ( buttons
  ) where

import Prelude ((>>=), bind, Unit, unit, (==), pure)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Services.Router as Router

buttons :: forall eff. D.Element -> Eff (st :: St, dom :: DOM | eff) Unit
buttons container = do
  buttonsEl <- D.div >>= D.text "Buttons"
  router <- Router.router
  _ <- S.behavior router \route -> if route.route == "buttons"
    then do
      _ <- D.append container buttonsEl
      pure unit
    else do
      _ <- D.remove buttonsEl
      pure unit
  pure unit
