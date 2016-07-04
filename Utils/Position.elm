module Utils.Position exposing (..)

import Mouse

type alias Position =
    Mouse.Position

type alias Positioned a =
    { a | position : Position }

fromXY : Int -> Int -> Position
fromXY x y =
    { x = x
    , y = y
    }

distanceBetween : Position -> Position -> Float
distanceBetween position1 position2 =
    let
        x1 = position1.x
        y1 = position1.y
        x2 = position2.x
        y2 = position2.y
    in
        sqrt (toFloat ((x2 - x1) ^ 2 + (y2 - y1) ^ 2))

move : Int -> Int -> Position -> Position
move x y position =
    { position | x = position.x + x
    , y = position.y + y
    }
