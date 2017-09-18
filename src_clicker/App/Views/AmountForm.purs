module App.Views.AmountForm
  ( form
  ) where

import Prelude ((>>=), pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Controls.Card (card)
import App.Controls.Clicker (clicker)

form :: forall eff. Eff (st :: St, dom :: DOM | eff) D.Element
form = do
  div <- D.div
  _ <- clicker >>= D.append div
  _ <- card >>= D.append div
  pure div
