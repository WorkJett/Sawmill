module App.Controls.Card
  ( Store
  , State
  , default
  , build
  , release
  ) where

import Prelude (Unit, unit, (>>=), pure, bind, show)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

type Store =
  { amount :: Int
  , element :: D.Element
  }

type State = S.State Store

default :: forall eff. Eff (st :: St, dom :: DOM | eff) State
default = do
  element <- D.div
  _ <- D.klass "info" element
  S.build
    { amount: 0
    , element: element
    }

build :: forall eff. State -> Eff (st :: St, dom :: DOM | eff) D.Element
build state = do
  store <- S.get state
  _ <- S.behavior state "local" \value -> do
    _ <- D.text (show value.amount) store.element
    pure unit
  pure store.element

release :: forall eff. State -> Eff (st :: St, dom :: DOM | eff) D.Element
release state = do
  store <- S.get state
  _ <- S.unsubscribe state "local"
  pure store.element
