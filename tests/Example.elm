module Example exposing (suite)

import Client exposing (responseDecoder)
import ElmFixtures.TestEndpoint exposing (example)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode
import Test exposing (..)


suite : Test
suite =
    test "properly decodes the response" <|
        \() ->
            let
                input =
                    """
                     { "stringExample" : "Hello"
                     , "numericExample" : 100 }
                    """

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
