![InfiniteMath](https://cdn.discordapp.com/attachments/542187455936462881/1072367668155383808/InfiniteMathLogo.png)

InfiniteMath is a module that allows you to surpass the double-precision floating-point number limit which is:

> -2.2250738585072014e+308 to 1.7976931348623158e+308

Or for math geeks out there:

> (-2.2250738585072014 * 10^308) to (1.7976931348623158 * 10^308)

This is normally perfectly fine for games, but sometimes you might want to go past that limit, even just a little bit. InfiniteMath allows you to have practically infinite numbers.
InfiniteMath uses strings instead of numbers in a clever way to get around the limit.

InfiniteMath's limit is about:

> -1e+1e+308 to 1e+1e+308

Or

> -1 * 10^(1 * 10^308) to 1 * 10^(1 * 10^308)

In simpler terms, Roblox's normal limit is 1 with 308 zeros. InfiniteMath's limit is 1 with 1e+308 zeros.

Fun fact, a googolplex is 1 * 10^(1 * 10^100), which means you can use a googolplex with InfiniteMath.

Numbers constructed from InfiniteMath supports arithmetic operators `(+, -, *, /, ^)` with constructed numbers and normal numbers, and comparison operators `(<, >, <=, >=, ==, ~=)` with other constructed numbers. InfiniteMath also has support for OrderedDataStores.

There are also suffixes up to `1e+12000`, after that all numbers will display scientific notation. If you want to see all the suffixes, here's a [google doc](https://docs.google.com/document/d/e/2PACX-1vTB2zhx8PCdu5HpV5kwqmNx8BV9RCv44qZaljlTb0Mm0nkzwMQ2cI6aupxrNktrlylsp-QnbES-XteP/pub) with them.

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

To start using InfiniteMath, first you want to construct a new number. To do so, we use `IM.new(number)` (We'll say IM is InfiniteMath from now on).
```lua
local Number = IM.new(1)
```

The number is stored as `"1, 0"`.
From here we can do math operations on this number `(+, -, *, /, ^, >, <, >=, <=, ==, ~=)`.

```lua
local Number = IM.new(1)

Number += 1
```
Now the number is `"2, 0"`, or `2`.

We can use normal numbers or other constructed numbers in math.
```lua
IM.new(1) + 1
--these are equal to eachother
IM.new(1) + IM.new(1)
```

For comparing `(<, >, <=, >=, ==, ~=)` you can only compare constructed numbers with constructed numbers. Attempting to do:
```lua
print(IM.new(1) == 2)
```
Will give you the error `attempt to compare number == table`. Sadly this is unavoidable, as it's a limitation of metatables.

There are also functions on a constructed number that you can use.

# Functions

### Number:GetSuffix

GetSuffix will return a string with the number and a suffix at the end, these suffixes will go up to `1e+12000`. After, it will default to returning scientific notation.

By default, it will return an abbreviated suffix (1K). Using `true` will use the default behavior. Using false will return the full suffix (1 Thousand).
```lua
print(IM.new(1000):GetSuffix(), IM.new(1000):GetSuffix(true), IM.new(1000):GetSuffix(false))
```
This will print `1K 1K 1 Thousand`.

### Number:ScientificNotation

ScientificNotation will return a string with the number formatted in scientific notation.
```lua
print(IM.new(1000):ScientificNotation())
```
This will print `1e+3`.

### Number:Reverse

Reverse will attempt to return the constructed number converted into a regular number. If the constructed number is above `1e+308` it will instead return `INF`.
```lua
print(IM.new("1, 3"):Reverse())
```
This will print `1000`.

### Number:GetZeros

GetZeros will return the amount of zeros in the constructed number.
```lua
print(IM.new(1000):GetZeros())
```
This will print `3`.

### Number:ConvertForLeaderboards

ConvertForLeaderboards will return a number that you can use for OrderedDataStores in order to create global leaderboards that have the same limit as InfinteMath.
```lua
print(IM.new(1000):ConvertForLeaderboards())
```
This will print `31000`.

### InfiniteMath:ConvertFromLeaderboards

ConvertFromLeaderboards will return a constructed number, and should be given a number created by Number:ConvertForLeaderboards. This is what you will display on global leaderboards using OrderedDataStores.
```lua
local ValueFromStore = IM.new(1000):ConvertForLeaderboards()
print(IM:ConvertFromLeaderboards(ValueFromStore))
```
This will print `1K`.
