---
sidebar_position: 3
---
# What is this?

InfiniteMath is a module that allows you to surpass the double-precision floating-point number limit which about:

> -10^308 to 10^308

This is normally perfectly fine for games, but sometimes you might want to go past that limit, even just a little bit. InfiniteMath allows you to have practically infinite numbers.
InfiniteMath stores 2 numbers instead of 1 in a clever way to get around the limit.

InfiniteMath's limit is about:

> -10^^308 to 10^^308

In simpler terms, Roblox's normal limit is 1 with 308 zeros. InfiniteMath's limit is 1 with 10^308 zeros.

Fun fact, a googolplex is 10^100^100, which means you can use a googolplex with InfiniteMath.

Numbers constructed from InfiniteMath supports arithmetic operators `(+, -, *, /, ^, %)` with constructed numbers and normal numbers, and comparison operators `(<, >, <=, >=, ==, ~=)` with other constructed numbers. InfiniteMath also has support for OrderedDataStores.

There are also suffixes up to `1e+12000`, after that all numbers will display scientific notation. If you want to see all the suffixes, here's a [google doc](https://docs.google.com/document/d/e/2PACX-1vTB2zhx8PCdu5HpV5kwqmNx8BV9RCv44qZaljlTb0Mm0nkzwMQ2cI6aupxrNktrlylsp-QnbES-XteP/pub) with them.

If you have a list that goes higher than `1e+12000` (Trillinovenonagintanongentillion/TRNNA), by all means share it with me, I'd love to see it.


# How does it work?

A normal number in Roblox looks like this:

> 1

Now if we were to convert that to InfiniteMath, it would look like:

> {1, 0}

To explain, we can construct a table out of a number by taking the coefficient and the exponent of a number.

Lets say we want to use `1000` with the module, we take the coefficient (1) and the exponent, which the amount of zeros (3) and put them in a table:

> {1, 3}

Now if we did something like `{1, 3} + {1, 2}`, we would get:

> {1.1, 3}

This gives us `1100`. And since we're not using numbers, we can go above the limit. For example, `{1, 1000}` is equal to 1 with 1000 zeros, or 1 Untrigintatrecentillion. We can continue all the way up until reaching `1e+308` zeros, which would look like:

> {1, 1e+308}

And if we tried to display that as a number, it would return `1e+1.e+308`, aka 1 with `1 * 10^308` zeros. This is practically infinite, and if you ever have a use for going higher I will be very surprised.
