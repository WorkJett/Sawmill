module App.Base.Radiobutton
  ( RadiobuttonState
  , radiobutton
  ) where

import Prelude ((>>=), bind, unit, pure, not, (&&))
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.BEM as BEM

bRadiobutton :: String
bRadiobutton = BEM.b "radiobutton"
mRadiobuttonChecked :: String
mRadiobuttonChecked = BEM.m bRadiobutton "checked"
mRadiobuttonUnChecked :: String
mRadiobuttonUnChecked = BEM.m bRadiobutton "unchecked"
mRadiobuttonDisChecked :: String
mRadiobuttonDisChecked = BEM.m bRadiobutton "dischecked"
mRadiobuttonDisUnChecked :: String
mRadiobuttonDisUnChecked = BEM.m bRadiobutton "disunchecked"
eView :: String
eView = BEM.e bRadiobutton "view"
mViewChecked :: String
mViewChecked = BEM.m eView "checked"
mViewUnChecked :: String
mViewUnChecked = BEM.m eView "unchecked"
mViewDisChecked :: String
mViewDisChecked = BEM.m eView "dischecked"
mViewDisUnChecked :: String
mViewDisUnChecked = BEM.m eView "disunchecked"

type RadiobuttonState = S.State { isChecked :: Boolean, isDisabled :: Boolean }

radiobutton :: forall eff. D.Element -> RadiobuttonState -> Eff (st :: St, dom :: DOM | eff) D.Element
radiobutton container state = do
  radiobuttonEl <- D.div >>= D.append container
  viewEl <- D.div >>= D.append radiobuttonEl
  _ <- S.behavior state \value -> do
    _ <- if value.isDisabled
      then if value.isChecked
        then do
          _ <- D.klass mRadiobuttonDisChecked radiobuttonEl
          _ <- D.klass mViewDisChecked viewEl
          pure unit
        else do
          _ <- D.klass mRadiobuttonDisUnChecked radiobuttonEl
          _ <- D.klass mViewDisUnChecked viewEl
          pure unit
      else if value.isChecked
        then do
          _ <- D.klass mRadiobuttonChecked radiobuttonEl
          _ <- D.klass mViewChecked viewEl
          pure unit
        else do
          _ <- D.klass mRadiobuttonUnChecked radiobuttonEl
          _ <- D.klass mViewUnChecked viewEl
          pure unit
    pure unit
  _ <- D.click radiobuttonEl \_ -> do
    value <- S.get state
    _ <- if not value.isDisabled && not value.isChecked
      then do
        _ <- S.set state (value { isChecked = true })
        pure unit
      else do
        pure unit
    pure unit
  pure radiobuttonEl
