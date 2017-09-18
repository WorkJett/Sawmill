module App.Base.CheckboxLabel
  ( checkboxLabel
  ) where

import Prelude (bind, unit, pure, not, (>>=))
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Base.Checkbox

checkboxLabel :: forall eff. D.Element -> CheckboxState -> Eff (st :: St, dom :: DOM | eff) D.Element
checkboxLabel container state = do
  labelEl <- D.div >>= D.append container
  D.click labelEl \_ -> do
    value <- S.get state
    _ <- if value.isDisabled
      then do
        pure unit
      else do
        _ <- S.set state (value { isChecked = not value.isChecked })
        pure unit
    pure unit
