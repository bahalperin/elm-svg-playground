module Subscriptions exposing (..)

import Shapes.Subscriptions
import Model exposing (Model)
import Messages exposing (Msg(..))

subscriptions : Model -> Sub Msg
subscriptions model =
    let
        shapeSubscriptions =
            model.shapes
                |> List.map Shapes.Subscriptions.subscriptions
                |> List.map (Sub.map ShapeMsg)
    in
        Sub.batch
            shapeSubscriptions
