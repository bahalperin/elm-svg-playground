module Update exposing (..)

import Shapes.Update
import Model exposing (Model)
import Messages exposing (Msg(..))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShapeMsg subMsg ->
            let
                (updatedShapes, shapeCommand) = Shapes.Update.update subMsg model.shapes
            in
                ( { model | shapes = updatedShapes }, Cmd.map ShapeMsg shapeCommand )
