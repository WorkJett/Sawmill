module App.Controls.SimpleForm
  ( simpleForm
  ) where

import Prelude (bind, Unit, unit, pure, (>>=), not, (<>))
import Control.Monad.Eff (Eff)
import Data.Array ((!!))
-- import Data.Maybe

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.BEM as BEM

import App.Base.Checkbox (checkbox)
import App.Base.Radiobutton (radiobutton)
import App.Base.RadiobuttonSet (radiobuttonSet)
import App.Base.RadiobuttonLabel (radiobuttonLabel)
import App.Base.CheckboxLabel (checkboxLabel)
import App.Base.TextField (textField)
import App.Base.Select.Select (select, SelectItem)
import App.Base.Multiselect (multiselect)
-- import App.Base.Autocomplete (autocomplete)

bForm :: String
bForm = BEM.b "simple-form"
eRow :: String
eRow = BEM.e bForm "row"
eLabel :: String
eLabel = BEM.e bForm "label"
eButton :: String
eButton = BEM.e bForm "button"
bButton :: String
bButton = BEM.b "button"
mButtonPrimary :: String
mButtonPrimary = BEM.m bButton "primary"
mButtonSecondary :: String
mButtonSecondary = BEM.m bButton "secondory"
bFlatButton :: String
bFlatButton = BEM.b "flat-button"
mFlatButtonPrimary :: String
mFlatButtonPrimary = BEM.m bFlatButton "primary"
mFlatButtonSecondary :: String
mFlatButtonSecondary = BEM.m bFlatButton "secondory"

selectItems :: Array SelectItem
selectItems =
  [ { id: 0, name: "Item one" }
  , { id: 1, name: "Item two" }
  , { id: 2, name: "Item three" }
  , { id: 3, name: "Item four" }
  ]

simpleForm :: forall eff. D.Element -> Eff (st :: St, dom :: DOM | eff) D.Element
simpleForm container = do
  formEl <- D.form >>= D.klass bForm >>= D.append container
  rowOne <- D.div >>= D.klass eRow >>= D.append formEl
  checkboxSt <- S.build { isChecked: false, isDisabled: false }
  checkboxEl <- checkbox rowOne checkboxSt
  checkboxLabelEl <- checkboxLabel rowOne checkboxSt >>= D.klass eLabel >>= D.text "test checkbox"
  rowTwo <- D.div >>= D.klass eRow >>= D.append formEl
  radioOneSt <- S.build { isChecked: true, isDisabled: false }
  radioOneEl <- radiobutton rowTwo radioOneSt
  _ <- S.behavior radioOneSt \value -> if not value.isDisabled
    then do
      _ <- S.update checkboxSt \checkBoxValue -> checkBoxValue { isDisabled = not value.isChecked }
      pure unit
    else do
        pure unit
  radioOneLabelEl <- radiobuttonLabel rowTwo radioOneSt >>= D.klass eLabel >>= D.text "enable checkbox"
  rowThree <- D.div >>= D.klass eRow >>= D.append formEl
  radioTwoSt <- S.build { isChecked: false, isDisabled: false}
  radioTwoEl <- radiobutton rowThree radioTwoSt
  radioTwoLabelEl <- radiobuttonLabel rowThree radioTwoSt >>= D.klass eLabel >>= D.text "disable checkbox"
  _ <- radiobuttonSet [radioOneSt, radioTwoSt]
  rowFour <- D.div >>= D.klass eRow >>= D.append formEl
  fieldOneSt <- S.build { text: "", label: "Placeholder" }
  fieldOneEl <- textField rowFour fieldOneSt
  rowFive <- D.div >>= D.klass eRow >>= D.append formEl
  buttonOneEl <- D.button >>= D.text "Button one" >>= D.klass (eButton <> " " <> mButtonPrimary) >>= D.append rowFive
  _ <- D.click buttonOneEl \event -> do
    _ <- D.preventDefault event
    pure unit
  buttonTwoEl <- D.button >>= D.text "Button two" >>= D.klass (eButton <> " " <> mButtonSecondary) >>= D.append rowFive
  _ <- D.click buttonTwoEl \event -> do
    _ <- D.preventDefault event
    pure unit
  rowSix <- D.div >>= D.klass eRow >>= D.append formEl
  buttonThreeEl <- D.button >>= D.text "Button three" >>= D.klass (eButton <> " " <> mFlatButtonPrimary) >>= D.append rowSix
  _ <- D.click buttonThreeEl \event -> do
    _ <- D.preventDefault event
    pure unit
  buttonFourEl <- D.button >>= D.text "Button four" >>= D.klass (eButton <> " " <> mFlatButtonSecondary) >>= D.append rowSix
  _ <- D.click buttonFourEl \event -> do
    _ <- D.preventDefault event
    pure unit
  rowSeven <- D.div >>= D.klass eRow >>= D.append formEl
  selectSt <- select rowSeven
  _ <- S.update selectSt \store -> store { items = selectItems, default = selectItems !! 0, isEmpty = true, label = "Test Select" }
  -- _ <- S.update selectSt \store -> store { items = selectItems, default = selectItems !! 0, isEmpty = false, label = "Test Select" }
  rowEight <- D.div >>= D.klass eRow >>= D.append formEl
  multiSt <- S.build { items: selectItems, label: "Test multiselect" }
  _ <- multiselect rowEight multiSt
  pure formEl
