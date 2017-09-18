module App.Services.Router
  ( Store
  , State
  , router
  , parse
  , toRoute
  , toRed
  , toGreen
  , toBlue
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

type Store = { route :: String }
type State = S.State Store

router :: forall eff. Eff (st :: St, dom :: DOM | eff) State
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

toRed :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
toRed = do
  _ <- toRoute "red"
  pure unit

toGreen :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
toGreen = do
  _ <- toRoute "green"
  pure unit

toBlue :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
toBlue = do
  _ <- toRoute "blue"
  pure unit

urlHandle :: forall eff. Eff (st :: St, dom :: DOM | eff) Unit
urlHandle = do
  routerState <- router
  _ <- S.subscribe routerState "routerUrlHandler" \route -> do
    _ <- History.pushState ("/" <> route.route) route.route
    pure unit
  pure unit
