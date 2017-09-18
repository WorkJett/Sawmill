module App.App
  ( Store
  , State
  , init
  ) where

import Prelude (Unit, unit, (>>=), pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Controls.Card as Card
import App.Controls.Clicker as Clicker

import App.Views.AmountForm as Form

type Store = { form :: Form.State }

type State = S.State Store

init :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
init = do
  appState <- S.store
  formState <- Form.default
  _ <- S.set appState
    { form: formState
    }
  formElement <- Form.build formState
  body <- D.body
  _ <- D.append body formElement
  pure unit
