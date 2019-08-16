-- Adapted from https://github.com/dateutil/dateutil/blob/bf71c95d73abe6d0c732116323802b41baf72b38/dateutil/easter.py
--
-- See http://www.tondering.dk/claus/cal/easter.php for info about the
-- algorithms.


module Easter exposing
    ( EasterMethod(..), easter
    , Date
    )

{-| This library makes it easy to compute the date of Easter for any given
year.

@docs Date, EasterMethod, easter

-}

import Time exposing (Month(..))


{-| A date consists of year, month and day. The `Month` type in
`elm/time` is used for the month.
-}
type alias Date =
    { year : Int
    , month : Month
    , day : Int
    }


{-| There are three different algorithms for computing the Easter
date. The `Western` algorithm is the most widely used nowadays.
-}
type EasterMethod
    = Julian
    | Orthodox
    | Western


{-| Compute the Easter date for the given method and year

    easter Western 2017 -- 2017-04-16

    easter Orthodox 1416 -- 1416-04-29

-}
easter : EasterMethod -> Int -> Date
easter method year =
    -- g - Golden year - 1
    -- c - Century
    -- h - (23 - Epact) mod 30
    -- i - Number of days from March 21 to Paschal Full Moon
    -- j - Weekday for PFM (0=Sunday, etc)
    -- p - Number of days from March 21 to Sunday on or before PFM
    --     (-6 to 28 Julian & Western, to 56 for Orthodox)
    -- e - Extra days to add for Orthodox method (converting Julian
    --     date to Gregorian date) - 10
    let
        y =
            year

        g =
            modBy 19 y

        pj yy =
            let
                i =
                    modBy 30 (19 * g + 15)

                j =
                    modBy 7 (yy + yy // 4 + i)
            in
            i - j

        p =
            case method of
                Julian ->
                    pj y

                Orthodox ->
                    let
                        e =
                            if y <= 1600 then
                                0

                            else
                                y // 100 - 16 - (y // 100 - 16) // 4
                    in
                    pj y + 10 + e

                Western ->
                    let
                        c =
                            y // 100

                        h =
                            modBy 30 (c - c // 4 - (8 * c + 13) // 25 + 19 * g + 15)

                        i =
                            h - (h // 28) * (1 - (h // 28) * (29 // (h + 1)) * ((21 - g) // 11))

                        j =
                            modBy 7 (y + y // 4 + i + 2 - c + c // 4)
                    in
                    i - j

        d =
            1 + modBy 31 (p + 27 + (p + 6) // 40)

        m =
            3 + (p + 26) // 30
    in
    Date y (monthFromMonthNumber m) d


monthFromMonthNumber : Int -> Month
monthFromMonthNumber m =
    case m of
        1 ->
            Jan

        2 ->
            Feb

        3 ->
            Mar

        4 ->
            Apr

        5 ->
            May

        6 ->
            Jun

        7 ->
            Jul

        8 ->
            Aug

        9 ->
            Sep

        10 ->
            Oct

        11 ->
            Nov

        -- We know that our algorithm works, so there's no need to
        -- prepare for out of range situations
        _ ->
            Dec
