module App.Controls.Card
  ( card
  ) where

import Prelude (unit, (>>=), pure, bind, show)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Services.Services as Srv

card :: forall eff. Eff (st :: St, dom :: DOM | eff) D.Element
card = do
  div <- D.div >>= D.klass "info"
  clickState <- Srv.click
  _ <- S.behavior clickState "toCard" \click -> do
    _ <- D.text (show click.amount) div
    pure unit
  pure div
