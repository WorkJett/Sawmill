module App.Views.Red
  ( red
  ) where

import Prelude ((>>=), bind, Unit, unit, (==), pure)
import Control.Monad.Eff (Eff)

import Sawmill.Store.Effect (St)
import Sawmill.Store.State as S

import Sawmill.DOM.Effect (DOM)
import Sawmill.DOM.HTML as D
import Sawmill.DOM.Timers as T

import App.Services.Router as Router

type Store = { isCurrent :: Boolean }
type State = S.State Store

onclick :: D.EventHandler
onclick _ = do
  Router.toGreen

red :: forall eff. D.Element -> Eff (st :: St, dom :: DOM | eff) Unit
red container = do
  state <- S.build { isCurrent: false }
  div <- D.div >>= D.klass "red hidden"
  button <- D.button >>= D.klass "btn" >>= D.text "To green"
  _ <- D.click button onclick
  router <- Router.router
  _ <- S.behavior router "redRoutingHandler" \route -> if route.route == "red"
    then do
      _ <- D.klass "red shown active show" div
      _ <- S.set state { isCurrent: true }
      pure unit
    else do
      store <- S.get state
      if store.isCurrent
        then do
          _ <- D.klass "red shown hide" div
          _ <- T.setTimeout 200 \_ -> do
            _ <- D.klass "red hidden" div
            pure unit
          _ <- S.set state { isCurrent: false }
          pure unit
        else do
          _ <- D.klass "red hidden" div
          pure unit
  _ <- D.append div button
  _ <- D.append container div
  pure unit
