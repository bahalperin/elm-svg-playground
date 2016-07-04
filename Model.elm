module Model exposing (..)

import Shapes.Model exposing (Shape)

type alias Model =
    { shapes : List Shape
    }

initialModel : Model
initialModel =
    { shapes = [ Shapes.Model.initialModel ]
    }
