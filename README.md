# elm-easter

![Status of direct dependencies](https://reiner-dolp.github.io/elm-badges/akheron/elm-easter/dependencies.svg)
![Latest Elm version supported](https://reiner-dolp.github.io/elm-badges/akheron/elm-easter/elm-version.svg)
![License of the package](https://reiner-dolp.github.io/elm-badges/akheron/elm-easter/license.svg)
![Latest version of the package](https://reiner-dolp.github.io/elm-badges/akheron/elm-easter/version.svg)

elm-easter is a pure Elm library for computing the date of Easter for
any given year, using Western, Orthodox or Julian algorithms.

## Example

    -- Easter in year 2017, according to Western (most common) algorithm
    easter Western 2017  -- 2017-04-16

    -- Easter in year 1416, according to the Orthodox algorithm
    easter Orthodox 1416  -- 1416-04-29

See the [akheron/elm-easter] package for full documentation.

## Development

Run the test suite:

    elm-test

[akheron/elm-easter]: http://package.elm-lang.org/packages/akheron/elm-easter/latest
