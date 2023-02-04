# InfiniteMath

InfiniteMath is a module that allows you to surpass the double-precision floating-point number limit which is:

> 2.2250738585072014e-308 to 1.7976931348623158e+308

Or for math geeks out there:

> (-2.2250738585072014 * 10^308) to (1.7976931348623158 * 10^308)

This is normally perfectly fine for games, but sometimes you might want to go past that limit, even just a little bit. InfiniteMath allows you to have practically infinite numbers.
InfiniteMath uses strings instead of numbers in a clever way to get around the limit.

There are suffixes up to `1e+12000`, after that all numbers will display scientific notation. If you want to see all the suffixes, here's a [google doc](https://docs.google.com/document/d/e/2PACX-1vTB2zhx8PCdu5HpV5kwqmNx8BV9RCv44qZaljlTb0Mm0nkzwMQ2cI6aupxrNktrlylsp-QnbES-XteP/pub) with them.

If you have a list that goes higher than `1e+12000` (Trillinovenonagintanongentillion/TRNNA), by all means share it with me, I'd love to see it.

# Explanation

A normal number in Roblox looks like this:

> 1

Now if we were to convert that to InfiniteMath, it would look like:

> "1, 0"

To explain, we can construct a string out of a number by taking the coefficient and the exponent, and splitting them up into a string.

Lets say we want to use `1000` with the module, we take the coefficient (1) and the exponent, which the amount of zeros (3) and put them in a string:

> "1, 3"

Now if we did something like `"1, 3" + "1, 2"`, we would get:

> "1.1, 3" (1100)

And since we're not using numbers, we can go above the limit. For example, `"1, 1000"` is equal to 1 with 1000 zeros, or 1 Untrigintatrecentillion. We can continue all the way up until reaching `1e+308` zeros, which would look like:

> "1, 1e+308"

And if we tried to display that as a number, it would return `1e+1.e+308`, aka 1 with `1 * 10^308` zeros. This is practically infinite, and if you ever have a use for going higher I will be very surprised.

# Constructing a number

To start using InfiniteMath, first you want to construct a new number. To do so, we use `IM.new(number)` (We'll say IM is InfiniteMath from now on)
```lua
local Number = IM.new(1)
```

Printing this will give us `"1, 0"`
From here we can do math operations on this number `(+, -, *, /, ^, >, <, >=, <=, ==)`

```lua
local Number = IM.new(1)

Number += 1
print(Number)
```
This will print `"2, 0"` to console.

We can use normal numbers or other constructed numbers in math.
```lua
IM.new(1) + 1
--these are equal to eachother
IM.new(1) + IM.new(1)
```

For comparing `(<, >, <=, >=, ==)` you can only compare constructed numbers with constructed numbers, and only normal numbers with normal numbers. Attempting to do
```lua
print(IM.new(1) == 2)
```
Will give you the error `attempt to compare number == table`

There are also functions on a constructed number that you can use.

# Functions

### GetAbbSuffix

GetAbbSuffix will return a string with the number and an abbreviated suffix at the end, these suffixes will go up to `1e+12000`. After, it will default to returning scientific notation.
```lua
print(IM.new(1000):GetAbbSuffix())
```
This will print `1K`

### GetSuffix

GetSuffix will return a string with the number and a suffix at the end, these suffixes will go up to `1e+12000`. After, it will default to returning scientific notation.
```lua
print(IM.new(1000):GetSuffix())
```
This will print `1 Thousand`

### ScientificNotation

ScientificNotation will return a string with the number formatted in scientific notation
```lua
print(IM.new(1000):ScientificNotation())
```
This will print `1e+3`

### Reverse

Reverse will attempt to return the constructed number converted into a regular number. If the constructed number is above `1e+308` it will instead return `INF`
```lua
print(IM.new("1, 3"):Reverse())
```
This will print `1000`

### GetZeros

GetZeros will return the amount of zeros in the constructed number.
```lua
print(IM.new(1000):GetZeros())
```
This will print `3`
