module Utils.List exposing (..)

foldl1 : (a -> a -> a) -> List a -> Maybe a
foldl1 func list =
    case list of
        [] ->
            Nothing
        [a] ->
            Just a
        a::b ->
            Just <| List.foldl func a b

minimumBy : (a -> comparable) -> List a -> Maybe a
minimumBy func list =
    foldl1 (\a b -> if (func a) < (func b) then a else b ) list

maximumBy : (a -> comparable) -> List a -> Maybe a
maximumBy func list =
    foldl1 (\a b -> if (func a) > (func b) then a else b ) list
