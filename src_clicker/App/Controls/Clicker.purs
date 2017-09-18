module App.Controls.Clicker
  ( clicker
  ) where

import Prelude (unit, (>>=), pure, bind, (+))
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Services.Services as Srv

onclick :: D.EventHandler
onclick _ = do
  clickState <- Srv.click
  _ <- S.update clickState \click -> click { amount = (click.amount + 1) }
  pure unit

clicker :: forall eff. Eff (st :: St, dom :: DOM | eff) D.Element
clicker = do
  button <- D.button >>= D.text "Clicker" >>= D.klass "btn clicker"
  D.click button onclick
