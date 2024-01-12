---
sidebar_position: 4
---

# Datastore Implementation

InfiniteMath uses metatables, meaning numbers created using it can't be saved in a datastore. If you do save an InfiniteMath number in a datastore, it will lose its metamethods which means no operations, comparisons, etc.

The solution is to recreate the number when loading it using `.new()`
```lua
local Money = InfiniteMath.new(1)

Data.Money = Money
```

When you want to use the number again, simply convert it back to an InfiniteMath number
```
local Money = InfiniteMath.new(Data.Money)
```
