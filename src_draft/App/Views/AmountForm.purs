module App.Views.AmountForm
  ( Store
  , State
  , default
  , build
  , release
  ) where

import Prelude (Unit, unit, (>>=), pure, bind)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Controls.Card as Card
import App.Controls.Clicker as Clicker

type Store =
  { card :: Card.State
  , clicker :: Clicker.State
  , element :: D.Element
  }

type State = S.State Store

default :: forall eff. Eff (st :: St, dom :: DOM | eff) State
default = do
  cardState <- Card.default
  clickerState <- Clicker.default
  element <- div
  S.build
    { card: cardState
    , clicker: clickerState
    , element: element
    }

build :: forall eff. State -> Eff (st :: St, dom :: DOM | eff) D.Element
build state = do
  store <- S.get state
  clickerElement <- Clicker.build store.clicker
  _ <- D.append store.element clickerElement
  cardElement <- Card.build store.card
  _ <- D.append store.element cardElement
  _ <- S.behavior store.clicker "clickerToCard" \value -> do
    cardStore <- S.get store.card
    _ <- S.set store.card (cardStore { amount = value.amount })
    pure unit
  pure store.element

release :: forall eff. State -> Eff (st :: St, dom :: DOM | eff) D.Element
release state = do
  store <- state
  _ <- S.unsubscribe store.clicker "clickerToCard"
  Clicker.release store.clicker
  Card.release store.card
  clickerStore <- S.get store.clicker
  _ <- D.remove clickerStore.element
  cardStore <- S.get store.card
  _ <- D.remove cardStore.element
  pure store.element
