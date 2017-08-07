-- Adapted from https://github.com/dateutil/dateutil/blob/bf71c95d73abe6d0c732116323802b41baf72b38/dateutil/easter.py


module Easter exposing (EasterMethod(Julian, Orthodox, Western), easter)

{-| This library makes it easy to compute the date of Easter for any given
year.

@docs EasterMethod, easter

-}

import Date exposing (Date)
import Date.Extra exposing (fromCalendarDate)
import Date.Extra.Facts exposing (monthFromMonthNumber)


{-| There are three different algorithms for computing the Easter
date. The `Western` algorithm is the most widely used nowadays.
-}
type EasterMethod
    = Julian
    | Orthodox
    | Western


{-| Compute the Easter date for the given method and year

    easter Western 2017  -- 2017-04-16
    easter Orthodox 1416  -- 1416-04-29

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
    --     date to Gregorian date)
    let
        y =
            year

        g =
            y % 19

        p =
            case method of
                Julian ->
                    let
                        i =
                            (19 * g + 15) % 30

                        j =
                            (y + y // 4 + i) % 7
                    in
                        i - j

                Orthodox ->
                    let
                        i =
                            (19 * g + 15) % 30

                        j =
                            (y + y // 4 + i) % 7

                        e =
                            10
                                + (if y <= 1600 then
                                    0
                                   else
                                    y // 100 - 16 - (y // 100 - 16) // 4
                                  )
                    in
                        i - j + e

                Western ->
                    let
                        c =
                            y // 100

                        h =
                            (c - c // 4 - (8 * c + 13) // 25 + 19 * g + 15) % 30

                        i =
                            h - (h // 28) * (1 - (h // 28) * (29 // (h + 1)) * ((21 - g) // 11))

                        j =
                            (y + y // 4 + i + 2 - c + c // 4) % 7
                    in
                        i - j

        d =
            1 + (p + 27 + (p + 6) // 40) % 31

        m =
            3 + (p + 26) // 30
    in
        fromCalendarDate y (monthFromMonthNumber m) d
