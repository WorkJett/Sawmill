module App.Base.Multiselect.ListItem
  ( ListItemState
  , listItem
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

bMultiselect :: String
bMultiselect = BEM.b "multiselect"
eListItem :: String
eListItem = BEM.e bMultiselect "listitem"
eListItemButton :: String
eListItemButton = BEM.e bMultiselect "listitem-button"
eListItemIcon :: String
eListItemIcon = BEM.e bMultiselect "listitem-icon"
eListItemLabel :: String
eListItemLabel = BEM.e bMultiselect "listitem-label"

type ListItemState = S.State { id :: Int, name :: String, selected :: Boolean }

listItem :: forall eff. D.Element -> ListItemState -> Eff (st :: St, dom :: DOM | eff) D.Element
listItem container state = do
  itemEl <- D.div >>= D.klass eListItem
  buttonEl <- D.div >>= D.klass eListItemButton >>= D.append itemEl
  iconEl <- D.div >>= D.klass eListItemIcon >>= D.append buttonEl
  labelEl <- D.div >>= D.klass eListItemLabel >>= D.append itemEl
  _ <- S.behavior state \item -> do
    _ <- D.text item.name labelEl
    _ <- if item.selected
      then do
        _ <- D.append container itemEl
        pure unit
      else do
        _ <- D.remove itemEl
        pure unit
    pure unit
  _ <- D.click buttonEl \_ -> do
    _ <- S.update state \value -> value { selected = false }
    pure unit
  pure itemEl
