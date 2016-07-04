module Main exposing (..)

import Html.App as Html

import Model exposing (Model, initialModel)
import View exposing (view)
import Update exposing (update)
import Messages exposing (Msg)
import Subscriptions exposing (subscriptions)

main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

init : ( Model, Cmd Msg )
init =
  ( initialModel, Cmd.none )
