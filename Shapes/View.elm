module Shapes.View exposing (..)

import Shapes.Model exposing (Shape, ShapeID, ShapeType(..))
import Shapes.Messages exposing (Msg(..))

import Html exposing (Html, div, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (on)

import Json.Decode as Json exposing ((:=))
import Mouse exposing (Position)

import Svg exposing (Svg, svg, rect)
import Svg.Attributes
import Svg.Events
import Svg.Lazy

import Utils.Drag

(=>) : a -> a -> (a, a)
(=>) = (,)

view : List Shape -> Html Msg
view shapes =
    let
        shapeSvgs =
            List.map (\shape -> Svg.Lazy.lazy drawShape shape) shapes
    in
        div [
            style
                [ "width" => "100%"
                ,"height" => "100%"
                ,"margin" => "0px"
                ,"position" => "absolute"
                ]
            ]
            [ addShapeButton
            , svg
                [ Svg.Attributes.width "100%", Svg.Attributes.height "100%"]
                shapeSvgs
            ]

drawShape : Shape -> Svg Msg
drawShape shape =
    let
        actualPosition =
            Utils.Drag.getPosition shape
        shapeSvg =
            rect
                [ onMouseDown shape
                , Svg.Events.onClick (Select shape.id)
                , Svg.Attributes.x (actualPosition.x - (shape.width // 2) |> toString)
                , Svg.Attributes.y (actualPosition.y - (shape.height // 2) |> toString)
                , Svg.Attributes.height (toString shape.height)
                , Svg.Attributes.width (toString shape.width)
                , Svg.Attributes.transform ("rotate(" ++ (toString shape.angle) ++ " " ++ (toString (actualPosition.x )) ++ " " ++ (toString (actualPosition.y )) ++ ")")
                , Svg.Attributes.fill (getColorForShape shape)
                ]
                []
        snapPoints =
            drawSnapPoints shape
        snapPointLines =
            drawSnapPointLines shape
        groupedSvgs =
            shapeSvg :: (snapPoints ++ snapPointLines)
    in
        Svg.g
            []
            groupedSvgs

drawSnapPoints : Shape -> List (Svg Msg)
drawSnapPoints shape =
    shape
        |> Shapes.Model.snapPoints
        |> List.map (\{position, angle} ->
            Svg.circle
                [ Svg.Attributes.cx (toString position.x)
                , Svg.Attributes.cy (toString position.y)
                , Svg.Attributes.r "10"
                , Svg.Attributes.style "fill:#aaa"
                ]
                []
            )

drawSnapPointLines : Shape -> List (Svg Msg)
drawSnapPointLines shape =
    shape
        |> Shapes.Model.snapPoints
        |> List.map (\{position, angle} ->
            Svg.line
                [ Svg.Attributes.x1 (toString position.x)
                , Svg.Attributes.y1 (toString position.y)
                , Svg.Attributes.x2 (position.x + (30 * cos (angle * (pi / 180)) |> round) |> toString)
                , Svg.Attributes.y2 (position.y + (30 * sin (angle * (pi / 180)) |> round) |> toString)
                , Svg.Attributes.stroke "black"
                , Svg.Attributes.strokeWidth "3"
                ]
                []
            )

addShapeButton : Html Msg
addShapeButton =
    button
        [ Html.Events.onClick <| Add Shapes.Model.initialModel
        , style
            [ "position" => "absolute"
            , "top" => "30px"
            , "left" => "0"
            ]
        ]
        [ text "Add a Shape"
        ]

onMouseDown : Shape -> Html.Attribute Msg
onMouseDown shape =
    on "mousedown" (Json.map (\position -> DragStart position shape) Mouse.position)

getColorForShape : Shape -> String
getColorForShape shape =
    if shape.selected then
        "#DDD"
    else
        "#3C8D2F"

px : Int -> String
px number =
    toString number ++ "px"
