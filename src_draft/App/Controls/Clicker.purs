module App.Controls.Clicker
  ( Store
  , State
  , default
  , build
  , release
  ) where

import Prelude (Unit, unit, (>>=), pure, bind, (+), (<>), show)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Base.Button as Btn

type Store =
  { amount :: Int
  , button :: Btn.State
  , element :: D.Element
  }

type State = S.State Store

title :: String
title = "Clicker"

klasses :: String
klasses = "btn clicker"

default :: forall eff. Eff (st :: St, dom :: DOM | eff) State
default = do
  buttonState <- Btn.default
  buttonStore <- S.get buttonState
  state <- S.build
    { amount: 0
    , button: buttonState
    , element: buttonStore.element
    }
  -- let onclick = \_ -> do
  --   store <- S.get state
  --   _ <- S.set state (store {amount = (store.amount + 1)})
  --   pure unit
  -- buttonStore <- S.get buttonState
  -- _ <- S.set buttonState (buttonsStore {onclick = onclick, title = title, klasses = klasses})
  pure state

build :: forall eff. State -> Eff (st :: St, dom :: DOM | eff) D.Element
build state = do
  store <- S.get state
  Btn.build store.button
  _ <- S.behavior state "local" \value -> do
    _ <- D.text (title <> " " <> show store.amount) button
    pure unit

release :: forall eff. Element -> State -> Eff (st :: St, dom :: DOM | eff) D.Element
release state = do
  store <- S.get state
  _ <- S.unsubscribe state "local"
  Btn.release store.button
