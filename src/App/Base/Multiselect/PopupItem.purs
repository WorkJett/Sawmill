module App.Base.Multiselect.PopupItem
  ( PopupItemState
  , popupItem
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

import App.Base.Checkbox
import App.Base.CheckboxLabel

bMultiselect :: String
bMultiselect = BEM.b "multiselect"
ePopupItem :: String
ePopupItem = BEM.e bMultiselect "popup-item"
ePopupItemCheckbox :: String
ePopupItemCheckbox = BEM.e bMultiselect "popup-item-checkbox"
ePopupItemLabel :: String
ePopupItemLabel = BEM.e bMultiselect "popup-item-label"

type PopupItemState = S.State { id :: Int, name :: String, selected :: Boolean }

popupItem :: forall eff. D.Element -> PopupItemState -> Eff (st :: St, dom :: DOM | eff) D.Element
popupItem container state = do
  itemEl <- D.div >>= D.klass ePopupItem >>= D.append container
  checkboxItemEl <- D.div >>= D.klass ePopupItemCheckbox >>= D.append itemEl
  checkboxSt <- S.build { isChecked: false, isDisabled: false }
  checkboxEl <- checkbox checkboxItemEl checkboxSt
  labelEl <- checkboxLabel itemEl checkboxSt >>= D.klass ePopupItemLabel
  _ <- S.behavior checkboxSt \value -> do
    item <- S.get state
    if item.selected /= value.isChecked
      then do
        _ <- S.set state (item { selected = value.isChecked })
        pure unit
      else do
        pure unit
    pure unit
  _ <- S.behavior state \value -> do
    _ <- D.text value.name labelEl
    checkbox <- S.get checkboxSt
    if checkbox.isChecked /= value.selected
      then do
        _ <- S.set checkboxSt (checkbox { isChecked = value.selected })
        pure unit
      else do
        pure unit
    pure unit
  pure itemEl
