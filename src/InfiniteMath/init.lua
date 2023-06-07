
--[=[
	@class InfiniteMath

	InfiniteMath module that creates numbers that surpass the limits of -10^308 to 10^308

	InfiniteMath has all the same functions as the math library.
]=]

--[=[
	An InfiniteMath number that surpasses the limits of -10^308 to 10^308

	@class Number

]=]

--[=[
	@prop DECIMALPOINTS number
	@within InfiniteMath

	How many decimal points are on a number. 1 is 1.1, 2 is 1.11, etc.
]=]

local InfiniteMath = {
	DECIMALPOINTS = 2,
}

local Number = {}
Number.__index = Number

--[[ Private variables ]]--


local THRESHOLD = 16
local LEADERBOARDPRECISION, LEADERBOARDPOINT = 10000, 5

local values = script.Values
local suffixes = require(values.Suffixes)
local full_names = require(values.FullNames)

--[[ Private functions ]]--
local function fixNumber(first, second)	
	first = tonumber(first)
	second = math.round(second)
	
	local sign = if first < 0 then -1 else 1
	local x

	if first == 0 or (second == 0 and first < 1) then
		return first, 0
	elseif second == 0 and first == 0 then
		return 0,0
	elseif first < 1 * sign then
		x = math.abs(first)
		local log10 = math.abs(math.floor(math.log10(x)))

		if log10 ~= 0 then -- Check if exponent is 0 then
			second -= log10
			x *= 10^log10
		end
		
	elseif first >= 1 * sign then
		x = math.abs(first)

		if math.floor(math.log10(x)) ~= 0 then -- Check if exponent is 0 then
			second += math.floor(math.log10(x))
			x /= 10^math.floor(math.log10(x))
		end
	end
	
	if x == nil then
		return 0/0, 0/0
	end
	
	if second < 0 then
		local Pow = math.abs(second)

		x /= 10^Pow
		second += Pow
	end
	
	return x*sign, second
end

local function convert(number)
	if typeof(number) ~= "number" then
		error('Type is not "number".')
	end
	
	-- get string representation
	local numberStr = tostring(number)
	local removed = 0

	if string.match(numberStr, "%.") and not string.match(numberStr, "e") then
		local split = string.split(numberStr, ".")
		numberStr = split[1]..""..split[2]
		removed = #split[2]
	end

	local first
	local second = #numberStr - 1 - removed

	if string.match(numberStr, "e") then
		second = numberStr:split("+")[2]
		first = numberStr:split("e")[1]
	elseif string.match(numberStr, "inf") then
		second = "inf"
		first = "inf"
	elseif string.match(numberStr, "nan") then
		second = "nan"
		first = "nan"
	else
		if #numberStr == 1 then
			first = number
		else
			local firstZ = numberStr:sub(1, 1)
			local secondZ = numberStr:sub(2)

			if tonumber(secondZ) > 0 then
				first = firstZ.."."..secondZ
			else
				first = firstZ
			end
		end
	end

	return first, second
end

local function checkNumber(a)
	if typeof(a) ~= "number" and typeof(a) ~= "string" and typeof(a) ~= "table" then
		error('"'..typeof(a)..'" is not a valid type. Please only use "number", "string", or constructed numbers.')
	end
	
	if typeof(a) == 'number' then
		a = InfiniteMath.new(a)
	end
	
	if typeof(a) == 'string' then
		a = InfiniteMath.new(a)
	end
	
	if a.first == nil and a.second == nil then
		error('"string" is not correctly formatted. Correctly formatted strings look like "1,0".')
	end
	
	return a
end

function replaceChar(pos, str, r)
	return table.concat{str:sub(1,pos-1), r, str:sub(pos+1)}
end

-- math metamethods:
function Number.__add(a, b)
	a, b = checkNumber(a), checkNumber(b)

	local first1, second1 = fixNumber(a.first, a.second)
	local first2, second2 = fixNumber(b.first, b.second)
	if math.abs(second1 - second2) > THRESHOLD then -- Check if difference in exponents is greater than threshold
		if math.max(second1, second2) == second1 then
			return InfiniteMath.new({first1, second1})
		end

		return InfiniteMath.new({first2, second2})
	end

	local difference = second1 - second2
	first2 *= (10^-difference)
	
	first1, second1 = fixNumber(first1 + first2, second1)

	return InfiniteMath.new({first1 , second1})
end

function Number.__sub(a, b)
	a, b = checkNumber(a), checkNumber(b)

	local first1, second1 = fixNumber(a.first, a.second)
	local first2, second2 = fixNumber(b.first, b.second)
	if math.abs(second1 - second2) > THRESHOLD then -- Check if difference in exponents is greater than threshold
		if math.max(second1, second2) == second1 then
			return InfiniteMath.new({first1 ,second1})
		end

		return InfiniteMath.new({first2, second2})
	end

	local difference = second1 - second2
	first2 *= (10^-difference)

	first1, second1 = fixNumber(first1 - first2, second1)

	return InfiniteMath.new({first1 , second1})
end

function Number.__mul(a, b)
	a, b = checkNumber(a), checkNumber(b)

	local first1, second1 = fixNumber(a.first, a.second)
	local first2, second2 = fixNumber(b.first, b.second)

	first1, second1 = fixNumber(first1 * first2, second1 + second2)

	return InfiniteMath.new({first1 , second1})
end

function Number.__div(a, b)
	a, b = checkNumber(a), checkNumber(b)

	local first1, second1 = fixNumber(a.first, a.second)
	local first2, second2 = fixNumber(b.first, b.second)
	
	first1, second1 = fixNumber(first1/first2, second1 - second2)

	return InfiniteMath.new({first1 , second1})
end

function Number.__pow(a, power)
	a = checkNumber(a)
	
	local first, second = fixNumber(a.first, a.second)

	if typeof(power) ~= "number" then
		power = power:Reverse()
	end

	local answer = InfiniteMath.new(1)
	
	local firstAnswer, secondAnswer

	if power > 1 then
		while power > 0 do
			local lastBit = (bit32.band(power, 1) == 1)

			if lastBit then
				answer *= a
			end

			a *= a

			power = bit32.rshift(power, 1)
		end
		
		firstAnswer, secondAnswer = fixNumber(answer.first, answer.second)
	elseif power == 0 then
		firstAnswer, secondAnswer = 1, 0
	else
		firstAnswer, secondAnswer = first, second
	end
	return InfiniteMath.new({firstAnswer, secondAnswer})
end

function Number.__mod(a, b)
	a, b = checkNumber(a), checkNumber(b)
	local sign = InfiniteMath.sign(a)
	
	local divided
	
	if sign == 1 then
		divided = InfiniteMath.floor(a / b)
	else
		divided = InfiniteMath.round(a / b)
	end
	
	local nextNum = b * divided
	
	return a - nextNum
end

function Number.__eq(a, b)
	a, b = checkNumber(a), checkNumber(b)

	if tostring(a.first) == "nan" or tostring(b.first) == "nan" then 
		return false 
	end

	return a.first == b.first and a.second == b.second
end

function Number.__lt(a, b)
	a, b = checkNumber(a), checkNumber(b)
	local first1, second1 = fixNumber(a.first, a.second)
	local first2, second2 = fixNumber(b.first, b.second)

	if second1 == second2 then
		return first1 < first2
	end

	return second1 < second2
end

function Number.__le(a, b)
	a, b = checkNumber(a), checkNumber(b)
	local first1, second1 = fixNumber(a.first, a.second)
	local first2, second2 = fixNumber(b.first, b.second)

	if second1 == second2 then
		return first1 <= first2
	end

	return second1 < second2
end

function Number.__unm(a)
	a = checkNumber(a)
	
	return a * -1
end

function Number.__tostring(self)
	return self:GetSuffix(true)
end

--[[ Class methods ]]--

--[=[
	@within InfiniteMath

	Returns a new InfiniteMath constructed number

	You can use numbers 1, correctly formatted strings "1,0", tables {1, 0}, and other constructed numbers InfiniteMath.new(1).

	```lua
		print(InfiniteMath.new(1)) -- 1
	```

	To create a number above 1e+308, we can use strings or tables.

	```lua
		print(InfiniteMath.new("1,1000")) -- 10DTL
		print(InfiniteMath.new({1, 1000})) -- 10DTL
	```

	@param val number | string | table
	@return Number
]=]
function InfiniteMath.new(val)	
	local first, second
	
	if typeof(val) == "table" then
		if val.first ~= nil and val.second ~= nil then return val end
		
		first = val[1]
		second = val[2]
	elseif typeof(val) == "string" then
		first, second = fixNumber(table.unpack(val:split(',')))
	elseif typeof(val) == 'number' then
		if val == 1e+999 then
			error('INF number is not allowed. Please use "string" or "table" instead of "number" to go above INF.')
		end
		
		first, second = convert(val)
	else
		error('"'..typeof(val)..'" is not a valid type. Please only use "number", "string", "table", or constructed numbers.')
		return
	end

	return setmetatable({
		first = first,
		second = second
	}, Number)
end

--[=[
	@within Number

	Returns the amount of zeroes in the number

	```lua
		print(InfiniteMath.new(1000):GetZeros()) -- 3
	```

	@method GetZeroes
	@return number
]=]

function Number:GetZeroes()
	return self.second
end

--[=[
	@within Number

	Reverse will attempt to return the constructed number converted into a regular number. If the constructed number is above 1e+308 it will instead return INF.

	```lua
		print(InfiniteMath.new("1, 3"):Reverse()) -- 1000
	```

	@method Reverse
	@return number
]=]

function Number:Reverse()
	local first, second = fixNumber(self.first, self.second)

	return tonumber(first.."e+"..second)
end

--[=[
	@within Number

	Returns a string with the number and a suffix at the end, these suffixes will go up to 1e+12000. After, it will default to returning scientific notation.

	By default, it will return an abbreviated suffix (1K). Using true will use the default behavior. Using false will return the full suffix (1 Thousand).

	```lua
		print(InfiniteMath.new(1000):GetSuffix()) -- 1K
		print(InfiniteMath.new(1000):GetSuffix(true)) -- 1K
		print(InfiniteMath.new(1000):GetSuffix(false)) -- 1 Thousand
	```

	@method GetSuffix
	@param abbreviation boolean | nil
	@return string
]=]

function Number:GetSuffix(abbreviation)
	if abbreviation == nil then 
		abbreviation = true 
	end

	local first, second = fixNumber(self.first, self.second)
	
	if second < 3 then 
		local result = tostring(self:Reverse())
		
		if InfiniteMath.DECIMALPOINTS > 0 then
			result = result:sub(1, second + 2 + InfiniteMath.DECIMALPOINTS)
		else
			result = result:split(".")[1]
		end
		
		return result
	end

	local secondRemainder = second % 3
	first *= 10^secondRemainder

	local suffixIndex = math.floor(second/3)
	local str = math.floor(first * 10^InfiniteMath.DECIMALPOINTS)/10^InfiniteMath.DECIMALPOINTS -- The * 10 / 10 controls decimal precision, more zeros = more decimals

	local suffix = if abbreviation then suffixes[suffixIndex] else (full_names[suffixIndex] and " " .. full_names[suffixIndex] or nil)

	if suffixIndex > 0 then
		if suffix ~= nil then
			str ..= suffix
		else
			str = self:ScientificNotation(abbreviation)
		end
	end

	return str
end

--[=[
	@within Number

	@param abbreviation boolean | nil
	@param abbreviate boolean | nil
	@return string
]=]

function Number:ScientificNotation(abbreviation, abbreviate)
	local first, second = fixNumber(self.first, self.second)
	first, second = tostring(first), tostring(second)
	
	local str = math.floor(first * 10^InfiniteMath.DECIMALPOINTS)/10^InfiniteMath.DECIMALPOINTS -- The * 10 / 10 controls decimal precision, more zeros = more decimals
	
	if tonumber(second) > 1e+6 and abbreviate ~= false then
		if abbreviation == true or abbreviation == nil then
			second = InfiniteMath.new(tonumber(second)):GetSuffix(true)
		else
			second = InfiniteMath.new(tonumber(second)):ScientificNotation(nil, false)
		end
	end

	return str.."e+"..second
end

function Number:LogarithmNotation()
	local first, second = fixNumber(self.first, self.second)
	first, second = tostring(first), tostring(second)

	local suffixIndex = math.floor(second/3)

	if suffixIndex == 0 then
		local secondRemainder = second % 3
		first *= 10^secondRemainder

		return math.floor(first * 10^InfiniteMath.DECIMALPOINTS)/10^InfiniteMath.DECIMALPOINTS
	end

	local log = tostring(math.log10(first))

	if string.match(log, "%.") then
		log = string.split(log, ".")
		log = log[2]:sub(1, 3)
	end

	return "e"..second.."."..log
end

local Alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}

function Number:aaNotation()
	local first, second = fixNumber(self.first, self.second)
	
	local secondRemainder = second % 3
	first *= 10^secondRemainder
	
	local suffixIndex = math.floor(second/3)
	
	if suffixIndex < 5 then
		return self:GetSuffix()
	end
	
	local n = suffixIndex

	local unitInt = n - 4
	local secondUnit = unitInt % 26
	local firstUnit = math.ceil(unitInt / 26)
	
	if firstUnit > 26 or secondUnit == 0 then
		return self:ScientificNotation()
	end
	
	local str = math.floor(first * 10^InfiniteMath.DECIMALPOINTS)/10^InfiniteMath.DECIMALPOINTS -- The * 10 / 10 controls decimal precision, more zeros = more decimals
	local unit = Alphabet[firstUnit]..Alphabet[secondUnit]
	
	return str..unit
end

function Number:ConvertForLeaderboards()
	local first, second = fixNumber(self.first, self.second)
	first, second = tostring(first), tostring(second)

	first = first:gsub("%.", "")

	return math.floor(tonumber(second.."."..first:sub(1, LEADERBOARDPOINT)) * LEADERBOARDPRECISION)
end

function InfiniteMath:ConvertFromLeaderboards(GivenNumber)
	GivenNumber /= LEADERBOARDPRECISION

	local numbers = tostring(GivenNumber):split('.')
	local second, first = numbers[1], numbers[2]

	local firstFirst = tostring(first):sub(1, 1)
	local firstSecond = tostring(first):sub(2)

	first = firstFirst.."."..firstSecond

	return InfiniteMath.new({first, second})
end

--[[ Math methods ]]--

--[=[
	@within InfiniteMath

	Rounds a number down to the nearest integer

	@param Num number | string | Number
	@return Number
]=]
function InfiniteMath.floor(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign
	
	local first, second = fixNumber(Num.first, Num.second)
	if second >= 3 then return Num * sign end
	
	return InfiniteMath.new(math.floor(Num:Reverse())) * sign
end

--[=[
	@within InfiniteMath

	Rounds a number to the nearest integer

	@param Num number | string | Number
	@return Number
]=]

function InfiniteMath.round(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign
	
	local _first, second = fixNumber(Num.first, Num.second)
	if second >= 3 then return Num * sign end

	local firstSplit = tostring(Num:Reverse()):split(".")

	if firstSplit[2] ~= nil then
		if tonumber(firstSplit[2]) >= 5 then
			return InfiniteMath.new(math.ceil(Num:Reverse())) * sign
		else
			return InfiniteMath.new(math.floor(Num:Reverse())) * sign
		end
	end

	return Num * sign
end

--[=[
	@within InfiniteMath

	Rounds a number up to the nearest integer

	@param Num number | string | Number
	@return Number
]=]

function InfiniteMath.ceil(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign
	
	local first, second = fixNumber(Num.first, Num.second)
	if second >= 3 then return Num * sign end

	return InfiniteMath.new(math.ceil(Num:Reverse())) * sign
end

--[=[
	@within InfiniteMath

	Returns the absolute value (distance from 0)

	@param Num number | string | Number
	@return Number
]=]

function InfiniteMath.abs(Num)
	Num = checkNumber(Num)
	local first, second = fixNumber(Num.first, Num.second)

	return InfiniteMath.new({math.abs(first), second})
end

--[=[
	@within InfiniteMath

	Clamps a number between a minimum and maximum value

	@param Num number | string | Number
	@param Min number | string | Number
	@param Max number | string | Number
	@return Number
]=]

function InfiniteMath.clamp(Num, Min, Max)
	Num = checkNumber(Num)
	local first, second = fixNumber(Num.first, Num.second)
	Num = InfiniteMath.new({first, second})
	
	if Min ~= nil then
		Min = checkNumber(Min)
		local firstMin, secondMin = fixNumber(Min.first, Min.second)
		Min = InfiniteMath.new({firstMin, secondMin})
	else
		Min = InfiniteMath.new(0)
	end
	
	if Max ~= nil then
		Max = checkNumber(Max)
		local firstMax, secondMax = fixNumber(Max.first, Max.second)
		Max = InfiniteMath.new({firstMax, secondMax})
	else
		Max = InfiniteMath.new("1, 1e+308")
	end
	
	print(Num < Min, Num, Min)
	
	Num = if Num < Min then Min elseif Num > Max then Max else Num
	
	return Num
end

--[=[
	@within InfiniteMath

	Returns the smallest number among the given arguments 

	@param ... number | string | Number
	@return Number
]=]

function InfiniteMath.min(...)
	local Numbers = {...}
	if Numbers[1] == nil then
		error("InfiniteMath.min requires at least 1 argument.")
	end
	
	for Index, Num in Numbers do
		Numbers[Index] = checkNumber(Num)
	end
	
	local Min = Numbers[1]
	
	for _, Num in Numbers do
		if Num < Min then
			Min = Num
		end
	end
	
	return Min
end

--[=[
	@within InfiniteMath

	Returns the largest number among the given arguments

	@param ... number | string | Number
	@return Number
]=]

function InfiniteMath.max(...)
	local Numbers = {...}
	if Numbers[1] == nil then
		error("InfiniteMath.max requires at least 1 argument.")
	end
	
	for Index, Num in Numbers do
		Numbers[Index] = checkNumber(Num)
	end

	local Max = Numbers[1]

	for _, Num in Numbers do
		if Num > Max then
			Max = Num
		end
	end

	return Max
end

--[=[
	@within InfiniteMath

	Returns the -1 if n < 0, if n == 0, or 1 if n > 0

	@param Num number | string | Number
	@return number
]=]

function InfiniteMath.sign(Num)
	Num = checkNumber(Num)
	local first, _ = fixNumber(Num.first, Num.second)
	first = tonumber(first)

	return if first > 0 then 1 elseif first < 0 then -1 else 0
end

--[=[
	@within InfiniteMath

	Returns the square root of a number

	@param Num number | string | Number
	@return Number
]=]

function InfiniteMath.sqrt(Num)
	return Num^.5
end

--[=[
	@within InfiniteMath

	Returns the remainder of the division of a by b that rounds the quotient towards zero.

	@param a number | string | Number
	@param b number | string | Number
	@return Number
]=]

function InfiniteMath.fmod(a, b)
	a, b = checkNumber(a), checkNumber(b)
	
	local divided = InfiniteMath.floor(a / b)
	local nextNum = b * divided
	
	return a - nextNum
end

--[=[
	@within InfiniteMath

	Returns both the integral part of n and the fractional part (if there is one). 

	@param Num number | string | Number
	@return Number
]=]

function InfiniteMath.modf(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign

	local first, second = fixNumber(Num.first, Num.second)
	local firstSplit = tostring(first):split(".")

	if firstSplit[2] ~= nil then
		first = firstSplit[2]:sub(1, second)
		first = firstSplit[1].."."..first
		
		local power = if second == 0 then 2 else second
		local decimal
		
		if second > 0 then
			decimal = firstSplit[2]:sub(power + 1) / 10^#firstSplit[2]:sub(power + 1)
		else
			decimal = firstSplit[2] / 10^#firstSplit[2]
		end

		return InfiniteMath.new({first, second}) * sign, decimal
	end

	return Num
end

--[=[
	@within InfiniteMath

	@param Num number | string | Number
	@param Base number
	@return Number
]=]

function InfiniteMath.log(Num, Base)
	if Base == nil then 
		Base = 2.7182818 
	end
	
	Num = checkNumber(Num)
	local first, second = fixNumber(Num.first, Num.second)
	
	return InfiniteMath.new(math.log(first, Base) + math.log(10^second, Base))
end

--[=[
	@within InfiniteMath

	Returns the base-10 logarithm of x.

	@param Num number | string | Number
	@return Number
]=]

function InfiniteMath.log10(Num)
	return InfiniteMath.log(Num, 10)
end

return InfiniteMath
