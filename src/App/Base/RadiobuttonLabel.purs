module App.Base.RadiobuttonLabel
  ( radiobuttonLabel
  ) where

import Prelude (bind, unit, pure, not, (>>=))
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Base.Radiobutton

radiobuttonLabel :: forall eff. D.Element -> RadiobuttonState -> Eff (st :: St, dom :: DOM | eff) D.Element
radiobuttonLabel container state = do
  labelEl <- D.div >>= D.append container
  D.click labelEl \_ -> do
    radioVal <- S.get state
    _ <- if not radioVal.isChecked
      then do
        _ <- S.set state (radioVal { isChecked = true })
        pure unit
      else do
        pure unit
    pure unit
