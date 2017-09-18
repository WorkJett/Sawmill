module App.Base.Select.Select
  ( Store
  , State
  , SelectItem
  , select
  ) where

-- import Prelude (Unit, bind, negate, not, pure, unit, (&&), (/=), (==), (>>=))
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

bSelect :: String
bSelect = BEM.b "select"
eLabel :: String
eLabel = BEM.e bSelect "label"
mLabelOpen :: String
mLabelOpen = BEM.m eLabel "open"
mLabelEmpty :: String
mLabelEmpty = BEM.m eLabel "empty"
mLabelText :: String
mLabelText = BEM.m eLabel "text"
eView :: String
eView = BEM.e bSelect "view"
mViewOpen :: String
mViewOpen = BEM.m eView "open"
eUnderline :: String
eUnderline = BEM.e bSelect "underline"
mUnderlineOpen :: String
mUnderlineOpen = BEM.m eUnderline "open"
mUnderlineClosed :: String
mUnderlineClosed = BEM.m eUnderline "closed"
eIndicator :: String
eIndicator = BEM.e bSelect "indicator"
mIndicatorOpen :: String
mIndicatorOpen = BEM.m eIndicator "open"
mIndicatorClosed :: String
mIndicatorClosed = BEM.m eIndicator "closed"
ePopup :: String
ePopup = BEM.e bSelect "popup"
mPopupOpen :: String
mPopupOpen = BEM.m ePopup "open"
eItems :: String
eItems = BEM.e bSelect "items"
eItem :: String
eItem = BEM.e bSelect "item"
mItemSelected :: String
mItemSelected = BEM.m eItem "selected"

type SelectItem = { id :: Int, name :: String }

emptyItem :: SelectItem
emptyItem = { id: -1, name: "Value is not selected" }

type Store =
  { items:: Array SelectItem
  , default :: Maybe SelectItem
  , isEmpty :: Boolean
  , label :: String
  }
type State = S.State Store

type LocalStore =
  { isOpen :: Boolean
  , selected :: SelectItem
  , selectedEl :: D.Element
  }
type LocalState = S.State LocalStore

buildEmptyItem :: forall eff. Eff (st :: St, dom :: DOM | eff) D.Element
buildEmptyItem = do
  D.div >>= D.text emptyItem.name >>= D.klass mItemSelected

buildItem :: forall eff. D.Element -> LocalState -> SelectItem -> D.Element -> Eff (st :: St, dom :: DOM | eff) Unit
buildItem parent state item itemEl = do
  store <- S.get state
  _ <- D.text item.name itemEl >>= D.append parent
  _ <- if item.id == store.selected.id
    then do
      _ <- D.klass eItem store.selectedEl
      _ <- D.klass mItemSelected itemEl
      _ <- S.set state (store { selectedEl = itemEl })
      pure unit
    else do
      _ <- D.klass eItem itemEl
      pure unit
  _ <- D.click itemEl \_ -> do
    localStore <- S.get state
    _ <- D.klass eItem localStore.selectedEl
    _ <- D.klass mItemSelected itemEl
    _ <- S.set state (localStore { selected = item, isOpen = false, selectedEl = itemEl })
    pure unit
  pure unit

setItem :: forall eff. LocalState -> (Maybe SelectItem) -> Eff (st :: St, dom :: DOM | eff) Unit
setItem state (Just item) = do
  _ <- S.update state \store -> store { selected = item  }
  pure unit
setItem state Nothing = do
  pure unit

select :: forall eff. D.Element -> Eff (st :: St, dom :: DOM | eff) State
select container = do
  state <- S.build { items: [], default: Nothing, isEmpty: true, label: "" }
  emptyItemEl <- buildEmptyItem
  localSt <- S.build { isOpen: false, selected: emptyItem, selectedEl: emptyItemEl }
  selectEl <- D.div >>= D.klass bSelect >>= D.append container
  labelEl <- D.div >>= D.klass eLabel >>= D.append selectEl
  indicatorEl <- D.div >>= D.klass mIndicatorClosed >>= D.append selectEl
  viewEl <- D.div >>= D.klass eView >>= D.append selectEl
  underlineEl <- D.div >>= D.klass eUnderline >>= D.append selectEl
  popupEl <- D.div >>= D.klass ePopup >>= D.append selectEl
  itemsEl <- D.div >>= D.klass eItems >>= D.append popupEl
  _ <- S.behavior state \store -> do
    localStore <- S.get localSt
    _ <- D.clear itemsEl
    _ <- D.text store.label labelEl
    _ <- if store.isEmpty
      then do
        _ <- buildItem itemsEl localSt emptyItem localStore.selectedEl
        pure unit
      else do
        pure unit
    _ <- setItem localSt store.default
    _ <- if isNothing store.default && not store.isEmpty && Arr.length store.items == 0
      then do
        _ <- buildItem itemsEl localSt emptyItem localStore.selectedEl
        pure unit
      else do
        pure unit
    _ <- if isNothing store.default && not store.isEmpty && Arr.length store.items /= 0
      then do
        _ <- setItem localSt (Arr.head store.items)
        pure unit
      else do
        pure unit
    _ <- for store.items \item -> do
      itemEl <- D.div
      _ <- buildItem itemsEl localSt item itemEl
      pure unit
    pure unit
  _ <- S.behavior localSt \localStore -> do
    _ <- D.text localStore.selected.name viewEl
    _ <- if localStore.isOpen
      then do
        _ <- D.klass mViewOpen viewEl
        _ <- D.klass mUnderlineOpen underlineEl
        _ <- D.klass mIndicatorOpen indicatorEl
        _ <- D.klass mPopupOpen popupEl
        _ <- if Str.length localStore.selected.name == 0
          then do
            _ <- D.klass (mLabelEmpty <> " " <> mLabelOpen) labelEl
            pure unit
          else do
            _ <- D.klass (mLabelText <> " " <> mLabelOpen) labelEl
            pure unit
        pure unit
      else do
        _ <- D.klass eView viewEl
        _ <- D.klass mUnderlineClosed underlineEl
        _ <- D.klass mIndicatorClosed indicatorEl
        _ <- D.klass ePopup popupEl
        _ <- if Str.length localStore.selected.name == 0
          then do
            _ <- D.klass mLabelEmpty labelEl
            pure unit
          else do
            _ <- D.klass mLabelText labelEl
            pure unit
        pure unit
    pure unit
  _ <- D.click viewEl \_ -> do
    _ <- S.update localSt \val -> val { isOpen = not val.isOpen }
    pure unit
  _ <- D.popupClose selectEl \_ -> do
    _ <- S.update localSt \val -> val { isOpen = false }
    pure unit
  pure state
