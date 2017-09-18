module App.Base.RadiobuttonSet
  ( radiobuttonSet
  ) where

import Prelude (bind, unit, pure, Unit, (&&), not)
import Data.Maybe (Maybe(..))
import Data.Traversable (for)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D

import App.Base.Radiobutton

type RadiobuttonSetState = S.State { states :: Array RadiobuttonState, current :: Maybe RadiobuttonState }

unsetState :: forall eff. Maybe RadiobuttonState -> Eff (st :: St, dom :: DOM | eff) Unit
unsetState (Just state) = do
  _ <- S.update state \value -> value { isChecked = false }
  pure unit
unsetState Nothing = do
  pure unit

unsetCurrent :: forall eff. RadiobuttonSetState -> Eff (st :: St, dom :: DOM | eff) Unit
unsetCurrent state = do
  store <- S.get state
  _ <- unsetState store.current
  pure unit

addHandler :: forall eff. RadiobuttonSetState -> RadiobuttonState -> Eff (st :: St, dom :: DOM | eff) Unit
addHandler state radioSt = do
  _ <- S.behavior radioSt \value -> do
    _ <- if not value.isDisabled && value.isChecked
      then do
        _ <- unsetCurrent state
        _ <- S.update state \store -> store { current = Just radioSt }
        pure unit
      else do
        pure unit
    pure unit
  pure unit

radiobuttonSet :: forall eff. Array RadiobuttonState -> Eff (st :: St, dom :: DOM | eff ) RadiobuttonSetState
radiobuttonSet states = do
  state <- S.build { states: states, current: Nothing }
  _ <- for states (addHandler state)
  pure state
