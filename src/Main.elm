module Main exposing (..)

import Html exposing (Html, text, div, h1, img, map)
import Html.Attributes exposing (src)
import Dropdown


---- MODEL ----


type alias Model =
    { selected : Maybe String, dropdown : Dropdown.Model }


init : ( Model, Cmd Msg )
init =
    let
        ( dropdown, dropdownCmd ) =
            Dropdown.init
    in
        ( { selected = Nothing, dropdown = dropdown }, Cmd.map ToDropdown dropdownCmd )



---- UPDATE ----


type Msg
    = ToDropdown Dropdown.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToDropdown dropdownMsg ->
            let
                ( newDropdown, dropdownCmd, dropdownEvent ) =
                    Dropdown.update model.dropdown dropdownMsg

                selectedOption =
                    case dropdownEvent of
                        Dropdown.Changed newSelectedOption ->
                            newSelectedOption

                        Dropdown.NoChange ->
                            model.selected
            in
                ( { model | selected = selectedOption, dropdown = newDropdown }, Cmd.map ToDropdown dropdownCmd )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ Dropdown.view model.selected Dropdown.defaultSettings [ "foo", "bar", "baz" ] model.dropdown |> Html.map ToDropdown
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
