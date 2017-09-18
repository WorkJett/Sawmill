module Sawmill.Store.State
  ( State
  , build
  , provider
  , get
  , set
  , update
  , subscribe
  , behavior
  , unsubscribe
  ) where

import Prelude (Unit)
import Control.Monad.Eff

import Sawmill.Store.Effect (St)

foreign import data State :: Type -> Type

foreign import build :: forall eff a. a -> Eff (st :: St | eff) (State a)
foreign import provider :: forall eff a. Eff (st :: St | eff) (State a)
foreign import get :: forall eff a. State a -> Eff (st :: St | eff) a
foreign import set :: forall eff a. State a -> a -> Eff (st :: St | eff) (State a)
foreign import update :: forall eff a. State a -> (a -> a) -> Eff (st :: St | eff) (State a)
foreign import subscribe :: forall eff a. State a -> String -> (a -> Eff (st :: St | eff) Unit) -> Eff (st :: St | eff) (State a)
foreign import behavior :: forall eff a. State a -> String -> (a -> Eff (st :: St | eff) Unit) -> Eff (st :: St | eff) (State a)
foreign import unsubscribe :: forall eff a. State a -> String -> Eff (st :: St | eff) (State a)
