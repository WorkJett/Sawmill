module App.Base.Multiselect.Popup
  ( popup
  ) where

import Prelude (Unit, bind, negate, not, pure, unit, (&&), (/=), (==), (>>=))
import Control.Monad.Eff (Eff)
import Data.String as Str
import Data.Array as Arr
import Prelude
import Data.Maybe (Maybe(..), isNothing)
import Data.Traversable (for)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.BEM as BEM

import App.Base.Multiselect.PopupItem (popupItem)

bMultiselect :: String
bMultiselect = BEM.b "multiselect"
ePopup :: String
ePopup = BEM.e bMultiselect "popup"
mPopupOpen :: String
mPopupOpen = BEM.m ePopup "open"
ePopupLabel :: String
ePopupLabel = BEM.e bMultiselect "popup-label"
ePopupButton :: String
ePopupButton = BEM.e bMultiselect "popup-button"
ePopupIcon :: String
ePopupIcon = BEM.e bMultiselect "popup-icon"
ePopupItems :: String
ePopupItems = BEM.e bMultiselect "popup-items"

type Item = { id :: Int, name :: String, selected :: Boolean }
type ItemState = S.State Item
type ItemsState = S.State { items:: Array ItemState }
type PopupState = S.State { title :: String, open :: Boolean }

popup :: forall eff. D.Element -> ItemsState -> PopupState -> Eff (st :: St, dom :: DOM | eff) D.Element
popup container itemsState popupState = do
  popupEl <- D.div >>= D.append container
  labelEl <- D.div >>= D.klass ePopupLabel >>= D.append popupEl
  buttonEl <- D.div >>= D.klass ePopupButton >>= D.append popupEl
  iconEl <- D.div >>= D.klass ePopupIcon >>= D.append buttonEl
  itemsEl <- D.div >>= D.klass ePopupItems >>= D.append popupEl
  _ <- S.behavior itemsState \value -> do
    _ <- for value.items \item -> do
      popupItemEl <- popupItem itemsEl item
      pure unit
    pure unit
  _ <- S.behavior popupState \value -> do
    _ <- D.text value.title labelEl
    _ <- if value.open
      then do
        _ <- D.klass mPopupOpen popupEl
        pure unit
      else do
        _ <- D.klass ePopup popupEl
        pure unit
    pure unit
  _ <- D.click buttonEl \_ -> do
    _ <- S.update popupState \value -> value { open = false }
    pure unit
  pure popupEl
