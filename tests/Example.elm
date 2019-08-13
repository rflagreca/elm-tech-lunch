module Example exposing (suite)

import Client exposing (responseDecoder)
import ElmFixtures.TestEndpoint exposing (example)
import Expect exposing (Expectation)
import Json.Decode
import Test exposing (..)


suite : Test
suite =
    test "properly decodes the response" <|
        \() ->
            let
                input =
                    example

                decoded =
                    Json.Decode.decodeString
                        responseDecoder
                        input
            in
            Expect.equal decoded
                (Ok
                    { stringExample = "Hello"
                    , numericExample = 100
                    }
                )
