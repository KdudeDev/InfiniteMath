# InfiniteMath

InfiniteMath is a module that allows you to surpass the double-precision floating-point number limit which is:

### 2.2250738585072014e-308 to 1.7976931348623158e+308

Or for math geeks out there:

### (-2.2250738585072014 * 10^308) to (1.7976931348623158 * 10^308)

This is normally perfectly fine for games, but sometimes you might want to go past that limit, even just a little bit. InfiniteMath allows you to have practically infinite numbers.
InfiniteMath uses strings instead of numbers in a clever way to get around the limit.

# Explanation

A normal number in Roblox looks like this:

1

Now if we were to convert that to InfiniteMath, it would look like:

"1, 0"

To explain, we can construct a string out of number by taking the coefficient and the exponent, and splitting them up into a string.

Lets say we want to use 1000 with the module, we take the coefficient (1) and the exponent, which the amount of zeros (3) and put them in a string:

"1, 3"

Now if we did something like "1, 3" (1000) + "1, 2" (100), we would get:

"1.1, 3" (1100)

And since we're not using numbers, we can go above the limit. For example, "1, 1000" is equal to 1 with 1000 zeros, or 1 Untrigintatrecentillion. We can continue all the way up until reaching 1e+308 zeros, which would look like:

"1, 1e+308"

And if we tried to display that as a number, it would return 1e+1.e+308, aka 1 with 1 * 10^308 zeros. This is practically infinite, and if you ever have a use for going higher I will be very surprised.
