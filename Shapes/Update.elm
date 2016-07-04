module Shapes.Update exposing (..)

import Shapes.Model exposing (Shape, Drag, SnapPoint)
import Shapes.Messages exposing (Msg(..))

import Utils.Drag
import Utils.List
import Utils.Position

update : Msg -> List Shape -> ( List Shape, Cmd Msg )
update msg shapes =
    case msg of
        DragStart xy dragShape ->
            (List.map (\shape -> if shape.id == dragShape.id then Utils.Drag.start xy shape else shape) shapes, Cmd.none)

        DragAt xy ->
            (List.map (Utils.Drag.at xy) shapes, Cmd.none)

        DragEnd _ dragShape ->
            let
                otherShapes =
                    List.filter (\shape -> shape.id /= dragShape.id) shapes
                updatedShape =
                    dragShape
                        |> dragEnd otherShapes
            in
                (List.map (\shape -> if shape.id == dragShape.id then updatedShape else shape) shapes, Cmd.none)

        Add shape ->
            let
                shapeID =
                    shapes
                        |> List.map .id
                        |> List.maximum
                        |> Maybe.withDefault 0
                        |> (\id -> id + 1)

                newShape = { shape | id = shapeID }
            in
                (newShape :: shapes, Cmd.none)
        Select shapeID ->
            (List.map (\shape -> { shape | selected = (shape.id == shapeID) }) shapes, Cmd.none)


dragEnd : List Shape -> Shape -> Shape
dragEnd otherShapes dragShape =
    let
        targetSnapPoints =
            otherShapes
                |> List.map Shapes.Model.snapPoints
                |> List.concat
        updatedShape =
            Utils.Drag.end dragShape
        maybeClosestSnapPoints =
            closestSnapPointForShape updatedShape targetSnapPoints
    in
        case maybeClosestSnapPoints of
            Just (dragPoint, otherPoint) ->
                if (Utils.Position.distanceBetween dragPoint.position otherPoint.position) < (Shapes.Model.snapRange |> toFloat) then
                    { updatedShape | position = Utils.Position.move (otherPoint.position.x - dragPoint.position.x) (otherPoint.position.y - dragPoint.position.y) updatedShape.position }
                else
                    updatedShape
            Nothing ->
                updatedShape

closestSnapPointForShape : Shape -> List SnapPoint -> Maybe (SnapPoint, SnapPoint)
closestSnapPointForShape shape targets =
    let
        shapeSnapPoints =
            Shapes.Model.snapPoints shape
        closestSnapPointPairs =
            shapeSnapPoints
                |> List.filterMap (\point ->
                    let
                        maybeClosestPoint =
                            point
                                |> getValidSnapPoints targets
                                |> (\filteredTargets -> getClosestSnapPoint filteredTargets point)
                    in
                        case maybeClosestPoint of
                            Just target ->
                                Just (point, target)
                            Nothing ->
                                Nothing
                )
    in
        Utils.List.minimumBy (\(point, closest) ->
            Utils.Position.distanceBetween point.position closest.position
        ) closestSnapPointPairs

getValidSnapPoints : List SnapPoint -> SnapPoint -> List SnapPoint
getValidSnapPoints targets point =
    List.filter (\point1 -> (abs (point.angle - point1.angle)) == 180) targets

getClosestSnapPoint : List SnapPoint -> SnapPoint -> Maybe SnapPoint
getClosestSnapPoint targets {position} =
    Utils.List.minimumBy (\point -> Utils.Position.distanceBetween position point.position) targets

partitionShapes : List Shape -> (Maybe Shape, List Shape)
partitionShapes shapes =
    let
        (shapesBeingDragged, otherShapes) = List.partition Utils.Drag.isBeingDragged shapes
    in
        (List.head shapesBeingDragged, otherShapes)
