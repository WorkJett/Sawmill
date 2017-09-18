module Sawmill.DOM.Timers
  ( TimeoutTimer
  , IntervalTimer
  , TimerHandler
  , setTimeout
  , setInterval
  , clearTimeout
  , clearInterval
  ) where

import Prelude (Unit)
import Control.Monad.Eff (Eff)

import Sawmill.DOM.Effect (DOM)
import Sawmill.Store.Effect (St)

foreign import data TimeoutTimer :: Type
foreign import data IntervalTimer :: Type

type TimerHandler = forall eff. Unit -> Eff (st :: St, dom :: DOM | eff) Unit

foreign import setTimeout :: forall eff. Int -> TimerHandler -> Eff (dom :: DOM | eff) TimeoutTimer
foreign import setInterval :: forall eff. Int -> TimerHandler -> Eff (dom :: DOM | eff) IntervalTimer
foreign import clearTimeout :: forall eff. TimeoutTimer -> Eff (dom :: DOM | eff) Unit
foreign import clearInterval :: forall eff. IntervalTimer -> Eff (dom :: DOM | eff) Unit
