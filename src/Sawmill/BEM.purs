module Sawmill.BEM
  ( b
  , e
  , m
  ) where

import Prelude

b :: String -> String
b block = block

e :: String -> String -> String
e block element = block <> "__" <> element

m :: String -> String -> String
m element modifire = element <> " " <> element <> "--" <> modifire
