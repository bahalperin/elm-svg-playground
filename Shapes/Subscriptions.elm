module Shapes.Subscriptions exposing (..)

import Shapes.Model exposing (Shape)
import Shapes.Messages exposing (Msg(..))

import Mouse

subscriptions : Shape -> Sub Msg
subscriptions model =
  case model.drag of
    Nothing ->
      Sub.none

    Just _ ->
      Sub.batch [ Mouse.moves DragAt, Mouse.ups (\position -> DragEnd position model) ]
