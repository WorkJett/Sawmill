module Sawmill.DOM.HTML
  ( Element
  , Event
  , EventHandler
  , body
  , one
  , many
  , div
  , button
  , klass
  , text
  , append
  , insert
  , before
  , click
  , unclick
  ) where

import Prelude (Unit)
import Data.Maybe (Maybe)
import Control.Monad.Eff (Eff)

import Sawmill.DOM.Effect (DOM)
import Sawmill.Store.Effect (St)

foreign import data Element :: Type
foreign import data Event :: Type

type EventHandler = forall eff. Event -> Eff (st :: St, dom :: DOM | eff) Unit

foreign import body :: forall eff. Eff (dom :: DOM | eff) Element
foreign import one :: forall eff. String -> Eff (dom :: DOM | eff) (Maybe Element)
foreign import many :: forall eff. String -> Eff (dom :: DOM | eff) (Array Element)
foreign import div :: forall eff. Eff (dom :: DOM | eff) Element
foreign import button :: forall eff. Eff (dom :: DOM | eff) Element
foreign import klass :: forall eff. String -> Element -> Eff (dom :: DOM | eff) Element
foreign import text :: forall eff. String -> Element -> Eff (dom :: DOM | eff) Element
foreign import append :: forall eff. Element -> Element -> Eff (dom :: DOM | eff) Element
foreign import insert :: forall eff. Element -> Element -> Eff (dom :: DOM | eff) Element
foreign import before :: forall eff. Element -> Element -> Eff (dom :: DOM | eff) Element
foreign import remove :: forall eff. Element -> Eff (dom :: DOM | eff) Element

foreign import click :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import unclick :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
