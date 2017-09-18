module App.Base.Button
  ( Store
  , State
  , default
  , build
  , release
  ) where

import Prelude (Unit, unit, (>>=), pure, bind, (+))
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

type Store =
  { title :: String
  , klasses :: String
  , element :: D.Element
  , onclick :: D.EventHandler
  }

type State = S.State Store

onclick :: D.EventHandler
onclick event = do
  pure unit

default :: forall eff. Eff (st :: St, dom :: DOM | eff) State
default = do
  element <- D.button
  state <- S.build
    { title: ""
    , klasses: ""
    , element: element
    , onclick: onclick
    }
  pure state

build :: forall eff. State -> Eff (st :: St, dom :: DOM | eff) D.Element
build state = do
  store <- S.get state
  _ <- D.click store.element store.onclick
  _ <- S.behavior state "local" \value -> do
    _ <- D.text value.title store.element
    _ <- D.klass value.klasses store.element
    pure unit
  pure store.element

release :: forall eff. State -> Eff (st :: St, dom :: DOM | eff) D.Element
release state = do
  store <- S.get state
  _ <- D.unclick store.element store.onclick
  _ <- S.unsubscribe state "local"
  pure store.element
