module Dropdown
    exposing
        ( Model
        , Msg
        , Settings
        , DropdownEvent(..)
        , defaultSettings
        , update
        , view
        , init
        )

import Html exposing (Html, div, ul, li, text, button)
import Html.Events exposing (onClick)


type alias Model =
    { isDropped : Bool }


type alias Settings =
    { placeholder : String, isDisabled : Bool }


defaultSettings : Settings
defaultSettings =
    { placeholder = "Pick an option", isDisabled = False }


init : Model
init =
    ({ isDropped = False })


type Msg
    = ToggleDropdown
    | ItemPicked String


type DropdownEvent
    = NoChange
    | Changed (Maybe String)


update : Model -> Msg -> ( Model, DropdownEvent )
update model msg =
    case msg of
        ToggleDropdown ->
            ( { model | isDropped = not model.isDropped }, NoChange )

        ItemPicked value ->
            ( { model | isDropped = False }, Changed (Just value) )


dropdownItemView : String -> Html Msg
dropdownItemView option =
    li [ onClick <| ItemPicked option ] [ text option ]


view : Maybe String -> Settings -> List String -> Model -> Html Msg
view selectedValue settings options model =
    div []
        [ div []
            [ div [] [ text (Maybe.withDefault settings.placeholder selectedValue) ]
            , button [ onClick ToggleDropdown ] [ text "X" ]
            ]
        , div []
            (if model.isDropped then
                [ ul [] (List.map dropdownItemView options) ]
             else
                []
            )
        ]
