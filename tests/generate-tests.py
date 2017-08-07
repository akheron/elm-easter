# Generate a test suite, using python-dateutil as the reference Easter
# computing implementation.

from dateutil.easter import easter, EASTER_JULIAN, EASTER_ORTHODOX, EASTER_WESTERN


elm_month_names = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
]


def elm_date(d):
    return "Date.fromCalendarDate %d %s %d" % (
        d.year,
        elm_month_names[d.month - 1],
        d.day,
    )


# Test against each Easter computing method
methods = [
    (EASTER_JULIAN, "julian"),
    (EASTER_ORTHODOX, "orthodox"),
    (EASTER_WESTERN, "western")
]

# Test against some arbitrary year ranges
year_ranges = [
    (1200, 1300),
    (1700, 1850),
    (1920, 2100),
]

print('''\
module Tests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, list, int, string)
import Test exposing (..)
import Date exposing (Date, Month(..))
import Date.Extra as Date
import Easter exposing (EasterMethod(..))


all : Test
all =
    describe "Easter tests"
        [ suite "Julian" Julian julianEasters
        , suite "Orthodox" Orthodox orthodoxEasters
        , suite "Western" Western westernEasters
        ]


suite : String -> EasterMethod -> List Date -> Test
suite methodName method easters =
    describe (methodName ++ " easters") <|
        List.map (genTest method) easters


genTest : EasterMethod -> Date -> Test
genTest method date =
    let
        year =
            Date.year date
    in
        test (toString year) <|
            \() -> (Expect.equal (Easter.easter method year) date)

''')

for method, method_name in methods:
    first = True
    print('%sEasters =' % method_name)
    print('    [ ', end='')
    for start_year, end_year in year_ranges:
        for year in range(start_year, end_year + 1):
            date = easter(year, method)
            if not first:
                print('\n    , ', end='')
            print(elm_date(date), end='')
            first = False
    print(' ]')
    print('')
    print('')
