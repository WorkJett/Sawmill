module App.Services.Router
  ( RouterState
  , router
  , parse
  , toRoute
  , toModals
  , toButtons
  , urlHandle
  ) where

import Prelude (Unit, unit, pure, bind, (<>))
import Control.Monad.Eff (Eff)

import Data.String (replace, Pattern(..), Replacement(..))

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect(DOM)
import Sawmill.DOM.Location as Location
import Sawmill.DOM.History as History

import App.Services.Services (services)

type RouterState = S.State { route :: String }

router :: forall eff. Eff (st :: St, dom :: DOM | eff) RouterState
router = do
  srvs <- services
  pure srvs.router

parse :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
parse = do
  path <- Location.pathname
  routerState <- router
  _ <- S.set routerState { route: (replace (Pattern "/") (Replacement "") path) }
  pure unit

toRoute :: forall eff. String -> Eff (st :: St, dom :: DOM | eff) Unit
toRoute route = do
  routerState <- router
  _ <- S.set routerState { route: route }
  pure unit

toModals :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
toModals = do
  _ <- toRoute "modals"
  pure unit

toButtons :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
toButtons = do
  _ <- toRoute "buttons"
  pure unit

urlHandle :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
urlHandle = do
  routerState <- router
  _ <- S.subscribe routerState \route -> do
    _ <- History.pushState ("/" <> route.route) route.route
    pure unit
  pure unit
