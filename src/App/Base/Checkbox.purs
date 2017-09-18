module App.Base.Checkbox
  ( CheckboxState
  , checkbox
  ) where

import Prelude ((>>=), bind, unit, pure, not)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.BEM as BEM

bCheckbox :: String
bCheckbox = BEM.b "checkbox"
mCheckboxChecked :: String
mCheckboxChecked = BEM.m bCheckbox "checked"
mCheckboxUnChecked :: String
mCheckboxUnChecked = BEM.m bCheckbox "unchecked"
mCheckboxDisChecked :: String
mCheckboxDisChecked = BEM.m bCheckbox "dischecked"
mCheckboxDisUnChecked :: String
mCheckboxDisUnChecked = BEM.m bCheckbox "disunchecked"
eView :: String
eView = BEM.e bCheckbox "view"
mViewChecked :: String
mViewChecked = BEM.m eView "checked"
mViewUnChecked :: String
mViewUnChecked = BEM.m eView "unchecked"
mViewDisChecked :: String
mViewDisChecked = BEM.m eView "dischecked"
mViewDisUnChecked :: String
mViewDisUnChecked = BEM.m eView "disunchecked"

type CheckboxState = S.State { isChecked :: Boolean, isDisabled :: Boolean }

checkbox :: forall eff. D.Element -> CheckboxState -> Eff (st :: St, dom :: DOM | eff) D.Element
checkbox container state = do
  checkboxEl <- D.div >>= D.append container
  viewEl <- D.div >>= D.append checkboxEl
  _ <- S.behavior state \value -> do
    _ <- if value.isDisabled
      then if value.isChecked
        then do
          _ <- D.klass mCheckboxDisChecked checkboxEl
          _ <- D.klass mViewDisChecked viewEl
          pure unit
        else do
          _ <- D.klass mCheckboxDisUnChecked checkboxEl
          _ <- D.klass mViewDisUnChecked viewEl
          pure unit
      else if value.isChecked
        then do
          _ <- D.klass mCheckboxChecked checkboxEl
          _ <- D.klass mViewChecked viewEl
          pure unit
        else do
          _ <- D.klass mCheckboxUnChecked checkboxEl
          _ <- D.klass mViewUnChecked viewEl
          pure unit
    pure unit
  _ <- D.click checkboxEl \_ -> do
    value <- S.get state
    _ <- if value.isDisabled
      then do
        pure unit
      else do
        _ <- S.set state (value { isChecked = (not value.isChecked) })
        pure unit
    pure unit
  pure checkboxEl
