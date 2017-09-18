module Sawmill.DOM.HTML
  ( Element
  , Event
  , EventHandler
  , body
  , one
  , many
  , div
  , form
  , button
  , checkbox
  , radiobutton
  , inputtext
  , klass
  , text
  , checked
  , id
  , name
  , getValue
  , append
  , insert
  , before
  , remove
  , clear
  , click
  , unclick
  , input
  , uninput
  , focus
  , unfocus
  , blur
  , unblur
  , stopPropagation
  , preventDefault
  , popupClose
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
foreign import form :: forall eff. Eff (dom :: DOM | eff) Element
foreign import button :: forall eff. Eff (dom :: DOM | eff) Element
foreign import checkbox :: forall eff. Eff (dom :: DOM | eff) Element
foreign import radiobutton :: forall eff. Eff (dom :: DOM | eff) Element
foreign import inputtext :: forall eff. Eff (dom :: DOM | eff) Element

foreign import klass :: forall eff. String -> Element -> Eff (dom :: DOM | eff) Element
foreign import text :: forall eff. String -> Element -> Eff (dom :: DOM | eff) Element
foreign import checked :: forall eff. Boolean -> Element -> Eff (dom :: DOM | eff) Element
foreign import id :: forall eff. String -> Element -> Eff (dom :: DOM | eff) Element
foreign import name :: forall eff. String -> Element -> Eff (dom :: DOM | eff) Element
foreign import getValue :: forall eff. Element -> Eff (dom :: DOM | eff) String
foreign import append :: forall eff. Element -> Element -> Eff (dom :: DOM | eff) Element
foreign import insert :: forall eff. Element -> Element -> Eff (dom :: DOM | eff) Element
foreign import before :: forall eff. Element -> Element -> Eff (dom :: DOM | eff) Element
foreign import remove :: forall eff. Element -> Eff (dom :: DOM | eff) Element
foreign import clear :: forall eff. Element -> Eff (dom :: DOM | eff) Element

foreign import click :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import unclick :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import input :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import uninput :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import focus :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import unfocus :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import blur :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element
foreign import unblur :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Element

foreign import stopPropagation :: forall eff. Event -> Eff (dom :: DOM | eff) Unit
foreign import preventDefault :: forall eff. Event -> Eff (dom :: DOM | eff) Unit
foreign import popupClose :: forall eff. Element -> EventHandler -> Eff (dom :: DOM | eff) Unit
