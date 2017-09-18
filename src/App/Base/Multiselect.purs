module App.Base.Multiselect
  ( multiselect
  ) where

import Prelude (bind, pure, unit, (<$>), (>>=))
import Control.Monad.Eff (Eff)
import Data.Traversable (for)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.BEM as BEM

import App.Base.Multiselect.Popup (popup)
import App.Base.Multiselect.ListItem (listItem)

bMultiselect :: String
bMultiselect = BEM.b "multiselect"
eLabel :: String
eLabel = BEM.e bMultiselect "label"
eButton :: String
eButton = BEM.e bMultiselect "button"
eIcon :: String
eIcon = BEM.e bMultiselect "icon"
eItems :: String
eItems = BEM.e bMultiselect "items"

type Item = { id :: Int, name :: String }
type MultiselectState = S.State { items :: Array Item, label :: String }

type MultiselectItem = { id :: Int, name :: String, selected :: Boolean }
type ItemState = S.State MultiselectItem
type ItemsState = S.State { items:: Array ItemState }

type PopupState = S.State { title :: String, open :: Boolean }

toMulti :: Item -> MultiselectItem
toMulti item = { id: item.id, name: item.name, selected: false }

multiselect :: forall eff. D.Element -> MultiselectState -> Eff (st :: St, dom :: DOM | eff) D.Element
multiselect container state = do
  multi <- S.get state
  itemsArraySt <- for (toMulti <$> multi.items) \item -> do
    itemSt <- S.build item
    pure itemSt
  itemsSt <- S.build { items: itemsArraySt }
  popupSt <- S.build { title: multi.label, open: false }
  multiselectEl <- D.div >>= D.klass bMultiselect >>= D.append container
  labelEl <- D.div >>= D.klass eLabel >>= D.text multi.label >>= D.append multiselectEl
  buttonEl <- D.div >>= D.klass eButton >>= D.append multiselectEl
  iconEl <- D.div >>= D.klass eIcon >>= D.append buttonEl
  itemsEl <- D.div >>= D.klass eItems >>= D.append multiselectEl
  popupEl <- popup multiselectEl itemsSt popupSt
  _ <- S.behavior itemsSt \value -> do
    _ <- for value.items \item -> do
      listItemEl <- listItem itemsEl item
      pure unit
    pure unit
  _ <- D.click buttonEl \_ -> do
    _ <- S.update popupSt \value -> value { open = true }
    pure unit
  _ <- D.popupClose multiselectEl \_ -> do
    _ <- S.update popupSt \val -> val { open = false }
    pure unit
  pure multiselectEl
