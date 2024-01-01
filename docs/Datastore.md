---
sidebar_position: 4
---

# Datastore Implementation

InfiniteMath uses metatables, meaning numbers created using it can't be saved in a datastore. 

The best way to store InfiniteMath numbers is as an array constructed using `Num.first` and `Num.second`
```lua
local Money = InfiniteMath.new(1)

Data.Money = {Money.first, Money.second}
```

When you want to use the number again, simply convert it back to an InfiniteMath number
```
local Money = InfiniteMath.new(Data.Money)
```

### Issue with storing as a dictionary

It's recommended not to store the number as a dictionary with `first` and second `values` such as
```lua
Data.Money = {first = Money.first, second = Money.second}
```
If you attempt to create an InfiniteMath number using this dictionary, it will assume it is already an InfiniteMath number and return without creating the metamethods it needs to.

If you really want to store numbers in that way, when you create the InfiniteMath number for use, construct an array using `first` and `second`
```
local Money = InfiniteMath.new({Data.Money.first, Data.Money.second})
```
