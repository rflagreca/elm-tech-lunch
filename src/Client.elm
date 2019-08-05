module Client exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode
import Json.Encode


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { endpoint : String
    , result : String
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            Model "http://localhost:4567/example" "Fetching"
    in
    ( model, fetch model )



-- UPDATE


type Msg
    = NoOp
    | GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotText result ->
            case result of
                Ok resp ->
                    ( { model | result = resp }, Cmd.none )

                Err err ->
                    ( model, Cmd.none )



-- HTTP


fetch : Model -> Cmd Msg
fetch model =
    Http.get
        { url = model.endpoint
        , expect = Http.expectString GotText
        }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text model.result ]


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none
