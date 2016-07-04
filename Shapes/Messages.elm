module Shapes.Messages exposing (Msg(..))

import Mouse exposing (Position)

import Shapes.Model exposing (Shape, ShapeID)

type Msg
    = DragStart Position Shape
    | DragAt Position
    | DragEnd Position Shape
    | Add Shape
    | Select ShapeID
