module Main exposing (..)

import Html exposing (Html, text, div, h1, img, map)
import Dropdown


---- MODEL ----


type alias Model =
    { selectedOne : Maybe String
    , dropdownOne : Dropdown.Model
    , selectedTwo : Maybe String
    , dropdownTwo : Dropdown.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { selectedOne = Nothing
      , dropdownOne = Dropdown.init
      , selectedTwo = Nothing
      , dropdownTwo = Dropdown.init
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ToDropdown Int Dropdown.Msg


updateDropdown : Int -> Dropdown.Msg -> Model -> Model
updateDropdown dropdownId dropdownMsg model =
    let
        ( newDropdown, dropdownEvent ) =
            Dropdown.update
                (if dropdownId == 1 then
                    model.dropdownOne
                 else
                    model.dropdownTwo
                )
                dropdownMsg

        selectedOption =
            case dropdownEvent of
                Dropdown.Changed newSelectedOption ->
                    newSelectedOption

                Dropdown.NoChange ->
                    if dropdownId == 1 then
                        model.selectedOne
                    else
                        model.selectedTwo
    in
        case dropdownId of
            1 ->
                { model | dropdownOne = newDropdown, selectedOne = selectedOption }

            2 ->
                { model | dropdownTwo = newDropdown, selectedTwo = selectedOption }

            _ ->
                model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToDropdown dropdownId dropdownMsg ->
            ( updateDropdown dropdownId dropdownMsg model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ Dropdown.view model.selectedOne Dropdown.defaultSettings [ "foo", "bar", "baz" ] model.dropdownOne |> Html.map (ToDropdown 1)
        , Dropdown.view model.selectedTwo Dropdown.defaultSettings [ "bloop", "fop", "far" ] model.dropdownTwo |> Html.map (ToDropdown 2)
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
