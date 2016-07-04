module Utils.Drag exposing (..)

import Utils.Position exposing (Position, Positioned)

type alias Drag =
    { start : Position
    , current : Position
    }

type alias Draggable a =
    Positioned { a | drag : Maybe Drag }

getPosition : Draggable a -> Position
getPosition {position, drag} =
    case drag of
        Nothing ->
            position

        Just {start,current} ->
            { x = (position.x + current.x - start.x)
            , y = (position.y + current.y - start.y)
            }

start : Position -> Draggable a -> Draggable a
start position item =
    { item | drag = Just { start = position, current = position } }

at : Position -> Draggable a -> Draggable a
at position item =
    if item.drag /= Nothing then
        { item | drag = Maybe.map (\{start} -> Drag start position) item.drag }
    else
        item

end : Draggable a -> Draggable a
end item =
    { item | position = getPosition item, drag = Nothing }

isBeingDragged : Draggable a -> Bool
isBeingDragged item =
    item.drag /= Nothing
