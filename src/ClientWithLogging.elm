module Client exposing (main, responseDecoder)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline as DecodePipeline exposing (required)
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
    , response : Response
    , fetchState : FetchState
    }


type alias Response =
    { stringExample : String
    , numericExample : Int
    }


type alias Flags =
    {}


type FetchState
    = Fetching
    | Success
    | Failure


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            Model "http://localhost:4567/example"
                { stringExample = ""
                , numericExample = 0
                }
                Fetching
    in
    ( model, fetch model )



-- UPDATE


type Msg
    = NoOp
    | GotText (Result Http.Error Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotText result ->
            case result of
                Ok resp ->
                    ( { model | response = resp, fetchState = Success }, Cmd.none )

                Err error ->
                    ( { model | fetchState = Failure }, logError error )



-- HTTP


fetch : Model -> Cmd Msg
fetch model =
    Http.request
        { method = "GET"
        , headers = []
        , url = model.endpoint
        , body = Http.emptyBody
        , expect = Http.expectJson GotText responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


logError : Http.Error -> Cmd Msg
logError error =
    let
        debug =
            Debug.log "Error" error
    in
    Cmd.none


responseDecoder : Decoder Response
responseDecoder =
    succeed Response
        |> DecodePipeline.required "stringExample" Json.Decode.string
        |> DecodePipeline.required "numericExample" Json.Decode.int



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text <| model.response.stringExample ++ " " ++ String.fromInt model.response.numericExample ]


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none
