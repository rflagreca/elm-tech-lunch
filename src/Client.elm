module Client exposing (main, responseDecoder)

import Browser
import Html exposing (Html, div, text)
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

                Err err ->
                    ( { model | fetchState = Failure }, Cmd.none )



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


responseDecoder : Decoder Response
responseDecoder =
    succeed Response
        |> DecodePipeline.required "stringExample" Json.Decode.string
        |> DecodePipeline.required "numericExample" Json.Decode.int



-- VIEW


view : Model -> Html Msg
view model =
    case model.fetchState of
        Fetching ->
            div [] [ text "Fetching" ]

        Failure ->
            div [] [ text "Fetch failed!" ]

        Success ->
            div []
                [ text <| model.response.stringExample ++ " " ++ String.fromInt model.response.numericExample ]


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none
