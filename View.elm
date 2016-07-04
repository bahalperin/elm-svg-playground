module View exposing (..)

import Model exposing (Model)
import Messages exposing (Msg(..))

import Html exposing (Html, div, text, header, h1)
import Html.App

import Shapes.View

view : Model -> Html Msg
view model =
    let
        shapesView =
            model.shapes
                |> Shapes.View.view
                |> Html.App.map ShapeMsg
    in
        div
            []
            [ shapesView
            ]
