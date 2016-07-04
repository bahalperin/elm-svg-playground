module Shapes.Model exposing (..)

import Utils.Position exposing (Position)
import Utils.Drag exposing (Draggable)

type ShapeType =
    Rectangle

type alias Drag =
    { start : Position
    , current : Position
    }

type alias ShapeID =
    Int

type alias Shape =
    Draggable { id : ShapeID
    , height : Int
    , width : Int
    , angle : Float
    , selected : Bool
    , shape : ShapeType
    }

shapeLeft : Shape -> Position
shapeLeft ({position, width, height, angle} as shape) =
    let
        actualPosition =
            Utils.Drag.getPosition shape
    in
        { x = actualPosition.x - (round ((cos (angle * (pi / 180))) * (toFloat (width // 2)))), y = actualPosition.y - (round ((sin (angle * (pi/180))) * (toFloat (width // 2)))) }

shapeRight : Shape -> Position
shapeRight ({position, width, height, angle} as shape) =
    let
        actualPosition =
            Utils.Drag.getPosition shape
    in
        { x = actualPosition.x + (round ((cos (angle * (pi / 180))) * (toFloat (width // 2)))), y = actualPosition.y + (round ((sin (angle * (pi/180))) * (toFloat (width // 2)))) }

shapeBottom : Shape -> Position
shapeBottom ({position, width, height, angle} as shape) =
    let
        actualPosition =
            Utils.Drag.getPosition shape
    in
        { x = actualPosition.x + (round ((sin (angle * (pi / 180))) * (toFloat (height // 2)))), y = actualPosition.y - (round ((cos (angle * (pi/180))) * (toFloat (height // 2)))) }

shapeTop : Shape -> Position
shapeTop ({position, width, height, angle} as shape) =
    let
        actualPosition =
            Utils.Drag.getPosition shape
    in
        { x = actualPosition.x - (round ((sin (angle * (pi / 180))) * (toFloat (height // 2)))), y = actualPosition.y + (round ((cos (angle * (pi/180))) * (toFloat (height // 2)))) }

type alias SnapPoint =
    { position : Position
    , angle : Float
    }

snapPoints : Shape -> List SnapPoint
snapPoints shape =
    [ { position = shapeLeft shape, angle = shape.angle + 180 }
    , { position = shapeRight shape, angle = shape.angle }
    , { position = shapeTop shape, angle = shape.angle + 90 }
    , { position = shapeBottom shape, angle = shape.angle - 90 }
    ]

snapRange : Int
snapRange = 100

initialModel : Shape
initialModel =
  { id = 1
  , position = Utils.Position.fromXY 200 200
  , drag = Nothing
  , shape = Rectangle
  , height = 100
  , angle = 0
  , selected = False
  , width = 100
  }
