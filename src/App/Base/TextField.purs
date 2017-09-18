module App.Base.TextField
  ( TextFieldState
  , textField
  ) where

import Prelude ((>>=), bind, unit, pure, (==))
import Control.Monad.Eff (Eff)
import Data.String (length)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.BEM as BEM

bTextField :: String
bTextField = BEM.b "textfield"
eLabel :: String
eLabel = BEM.e bTextField "label"
mLabelFocus :: String
mLabelFocus = BEM.m eLabel "focus"
mLabelBlur :: String
mLabelBlur = BEM.m eLabel "blur"
eInput :: String
eInput = BEM.e bTextField "input"
eUnderline :: String
eUnderline = BEM.e bTextField "underline"
mUnderlineFocus :: String
mUnderlineFocus = BEM.m eUnderline "focus"
mUnderlineBlur :: String
mUnderlineBlur = BEM.m eUnderline "blur"

type TextFieldState = S.State { text :: String, label :: String }

textField :: forall eff. D.Element -> TextFieldState -> Eff (st :: St, dom :: DOM | eff) D.Element
textField container state = do
  textFieldEl <- D.div >>= D.klass bTextField >>= D.append container
  labelEl <- D.div >>= D.klass eLabel >>= D.append textFieldEl
  inputEl <- D.inputtext >>= D.klass eInput >>= D.append textFieldEl
  underlineEl <- D.div >>= D.klass eUnderline >>= D.append textFieldEl
  _ <- D.input inputEl \_ -> do
    text <- D.getValue inputEl
    _ <- S.update state \value -> value { text = text }
    pure unit
  _ <- S.behavior state \value -> do
    _ <- D.text value.label labelEl
    _ <- if length value.text == 0
      then do
        _ <- D.klass mLabelBlur labelEl
        pure unit
      else do
        _ <- D.klass mLabelFocus labelEl
        pure unit
    pure unit
  _ <- D.focus inputEl \_ -> do
    _ <- D.klass mUnderlineFocus underlineEl
    _ <- D.klass mLabelFocus labelEl
    pure unit
  _ <- D.blur inputEl \_ -> do
    _ <- D.klass mUnderlineBlur underlineEl
    textField <- S.get state
    _ <- if length textField.text == 0
      then do
        _ <- D.klass mLabelBlur labelEl
        pure unit
      else do
        pure unit
    pure unit
  pure textFieldEl
