local InfiniteMath = {}
local Number = {}

Number.__index = Number

----- Private variables -----
local THRESHOLD = 10 -- How accurate math is, max is 16 (16 is how many decimal places you can have on a number)
local LEADERBOARDPRECISION, DECIMALPOINT = 10000, 4 -- How accurate leaderboards are

local suffixes = require(script.Suffixes)
local full_names = require(script.FullNames)

----- Private functions -----
local function fixNumber(first, second)	
	first = tonumber(first)
	second = math.round(tonumber(second))
	
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

	if string.match(numberStr, "%.") then
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

	return `{first},{second}`
end

local function checkNumber(a)
	if typeof(a) ~= "number" and typeof(a) ~= "string" and typeof(a) ~= "table" then
		error('"'..typeof(a)..'" is not a valid type. Please only use "number", "string", or constructed numbers.')
	end
	
	if typeof(a) == 'number' then
		a = InfiniteMath.new(convert(a))
	end
	
	if typeof(a) == 'string' then
		a = InfiniteMath.new(a)
	end
	
	if a.val == nil then
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

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))
	if math.abs(second1 - second2) > THRESHOLD then -- Check if difference in exponents is greater than threshold
		if math.max(second1, second2) == second1 then
			return InfiniteMath.new(`{first1},{second1}`)
		end

		return InfiniteMath.new(`{first2},{second2}`)
	end

	local difference = second1 - second2
	first2 *= (10^-difference)
	
	first1, second1 = fixNumber(first1 + first2, second1)

	return InfiniteMath.new(`{first1},{second1}`)
end

function Number.__sub(a, b)
	a, b = checkNumber(a), checkNumber(b)

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))
	if math.abs(second1 - second2) > THRESHOLD then -- Check if difference in exponents is greater than threshold
		if math.max(second1, second2) == second1 then
			return InfiniteMath.new(`{first1},{second1}`)
		end

		return InfiniteMath.new(`{first2},{second2}`)
	end

	local difference = second1 - second2
	first2 *= (10^-difference)

	first1, second1 = fixNumber(first1 - first2, second1)

	return InfiniteMath.new(`{first1},{second1}`)
end

function Number.__mul(a, b)
	a, b = checkNumber(a), checkNumber(b)

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	first1, second1 = fixNumber(first1 * first2, second1 + second2)

	return InfiniteMath.new(`{first1},{second1}`)
end

function Number.__div(a, b)
	a, b = checkNumber(a), checkNumber(b)

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	first1, second1 = fixNumber(first1/first2, second1 - second2)

	return InfiniteMath.new(`{first1},{second1}`)
end

function Number.__pow(a, power)
	a = checkNumber(a)
	
	local first, second = fixNumber(table.unpack(a.val:split(',')))

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
		
		firstAnswer, secondAnswer = fixNumber(table.unpack(answer.val:split(',')))
	elseif power == 0 then
		firstAnswer, secondAnswer = 1, 0
	else
		firstAnswer, secondAnswer = first, second
	end
	return InfiniteMath.new(`{firstAnswer},{secondAnswer}`)
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
	return a.val == b.val
end

function Number.__lt(a, b)
	a, b = checkNumber(a), checkNumber(b)
	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	if second1 == second2 then
		return first1 < first2
	end

	return second1 < second2 and first1 >= 0
end

function Number.__le(a, b)
	a, b = checkNumber(a), checkNumber(b)
	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	if second1 == second2 then
		return first1 <= first2
	end

	return second1 < second2 and first1 >= 0
end

function Number.__unm(a)
	a = checkNumber(a)
	
	return a * -1
end

function Number.__tostring(self)
	return self:GetSuffix(true)
end

---- Class methods -----
function InfiniteMath.new(val)
	if typeof(val) ~= "number" and typeof(val) ~= "string" and typeof(val) ~= "table" then
		error('"'..typeof(val)..'" is not a valid type. Please only use "number", "string", or constructed numbers.')
		return
	end

	-- fix up val for evaluation
	if typeof(val) == "table" then
		val = val.val
	end
	
	if typeof(val) ~= 'string' or #val:split(',') ~= 2 then
		if tonumber(val) == 1e+999 then
			print(typeof(val))
			if typeof(val) == "string" then
				if string.match(val, "e+") then
					local errorString = val:split("e+")
					error('String formatted incorrectly. Please use "string" "'..errorString[1]..","..errorString[2]..'"')
				else
					error('String formatted incorrectly.')
				end
			else
				error('INF number is not allowed. Please use "string" instead of "number" to go above INF. "string" limit is "1,1e+308"')
			end
		end
		val = convert(tonumber(val))
	end

	val = val:gsub(" ", "")

	local first, second = fixNumber(table.unpack(val:split(',')))
	val = first..","..second

	return setmetatable({
		val = val
	}, Number)
end

function Number:GetZeroes()
	return self.val:split(',')[2]
end

function Number:Reverse()
	local first, second = fixNumber(table.unpack(self.val:split(',')))

	return tonumber(first.."e+"..second)
end

function Number:ScientificNotation(abbreviation, abbreviate)
	local first, second = fixNumber(table.unpack(self.val:split(',')))
	first, second = tostring(first), tostring(second)
	
	local str = math.floor(first * 10)/10 -- The * 10 / 10 controls decimal precision, more zeros = more decimals
	
	if tonumber(second) > 1e+6 and abbreviate ~= false then
		if abbreviation == true or abbreviation == nil then
			second = InfiniteMath.new(tonumber(second)):GetSuffix(true)
		else
			second = InfiniteMath.new(tonumber(second)):ScientificNotation(nil, false)
		end
	end

	return str.."e+"..second -- Add 1 to numberPrecision to account for the decimal point
end

function Number:GetSuffix(abbreviation)
	if abbreviation == nil then abbreviation = true end

	local first, second = fixNumber(table.unpack(self.val:split(',')))

	first = tonumber(first)
	second = tonumber(second)

	local secondRemainder = second % 3
	first *= 10^secondRemainder

	local suffixIndex = math.floor(second/3)
	local str = math.floor(first * 10)/10 -- The * 10 / 10 controls decimal precision, more zeros = more decimals

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

function Number:ConvertForLeaderboards()
	local first, second = fixNumber(table.unpack(self.val:split(',')))
	first, second = tostring(first), tostring(second)

	first = first:gsub("%.", "")

	return math.floor(tonumber(second.."."..first:sub(1, DECIMALPOINT)) * LEADERBOARDPRECISION)
end

function InfiniteMath:ConvertFromLeaderboards(GivenNumber)
	GivenNumber /= LEADERBOARDPRECISION

	local numbers = tostring(GivenNumber):split('.')
	local second, first = numbers[1], numbers[2]

	local firstFirst = tostring(first):sub(1, 1)
	local firstSecond = tostring(first):sub(2)

	first = firstFirst.."."..firstSecond

	return InfiniteMath.new(`{first},{second}`)
end

---- Math methods -----

function InfiniteMath.floor(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign
	
	local first, second = fixNumber(table.unpack(Num.val:split(',')))
	local firstSplit = tostring(first):split(".")
	
	if firstSplit[2] ~= nil then
		first = firstSplit[2]:sub(1, second)
		first = firstSplit[1].."."..first
	end
	
	return InfiniteMath.new(`{first},{second}`) * sign
end

function InfiniteMath.round(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign
	
	local first, second = fixNumber(table.unpack(Num.val:split(',')))
	
	if #tostring(first) <= second + 2 then return Num * sign end
	local firstSplit = tostring(first):split(".")

	if firstSplit[2] ~= nil then
		first = firstSplit[2]:sub(second + 1)
		
		if tonumber(firstSplit[2]) / 10^#first >= .5 then
			return InfiniteMath.ceil(Num * sign)
		else
			return InfiniteMath.floor(Num * sign)
		end
	end

	return Num * sign
end

function InfiniteMath.abs(Num)
	Num = checkNumber(Num)
	local first, second = fixNumber(table.unpack(Num.val:split(',')))
	
	return InfiniteMath.new(`{math.abs(first)},{second}`)
end

function InfiniteMath.ceil(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign
	
	local first, second = fixNumber(table.unpack(Num.val:split(',')))

	if #tostring(first) <= second + 2 then return InfiniteMath.new(`{first},{second}`) end

	local firstSplit = tostring(first):split(".")

	if firstSplit[2] ~= nil then
		first = firstSplit[2]:sub(1, second)
		first = if first ~= "" then firstSplit[1].."."..first else firstSplit[1]

		if second > 0 then
			if tonumber(first:sub(second + 2) + 1) < 10 then
				first = replaceChar(second + 2, first, tonumber(first:sub(second + 2) + 1))
			else
				first = replaceChar(second + 2, first, 0)
				first = replaceChar(second, first, tonumber(first:sub(second) + 1))
			end
		else
			first = replaceChar(1, first, tonumber(first:sub(1, 1) + 1))
		end
	end

	return InfiniteMath.new(`{first},{second}`) * sign
end

function InfiniteMath.clamp(Num, Min, Max)
	Num = checkNumber(Num)
	local first, second = fixNumber(table.unpack(Num.val:split(',')))
	Num = InfiniteMath.new(`{first},{second}`)
	
	if Min ~= nil then
		Min = checkNumber(Min)
		local firstMin, secondMin = fixNumber(table.unpack(Min.val:split(',')))
		Min = InfiniteMath.new(`{firstMin},{secondMin}`)
	else
		Min = InfiniteMath.new(0)
	end
	
	if Max ~= nil then
		Max = checkNumber(Max)
		local firstMax, secondMax = fixNumber(table.unpack(Max.val:split(',')))
		Max = InfiniteMath.new(`{firstMax},{secondMax}`)
	else
		Max = InfiniteMath.new("1, 1e+308")
	end
	
	Num = if Num < Min then Min elseif Num > Max then Max else Num
	
	return Num
end

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

function InfiniteMath.sign(Num)
	Num = checkNumber(Num)
	local first, _ = fixNumber(table.unpack(Num.val:split(',')))
	first = tonumber(first)

	return if first > 0 then 1 elseif first < 0 then -1 else 0
end

function InfiniteMath.sqrt(Num)
	return Num^.5
end

function InfiniteMath.fmod(a, b)
	a, b = checkNumber(a), checkNumber(b)
	
	local divided = InfiniteMath.floor(a / b)
	local nextNum = b * divided
	
	return a - nextNum
end

function InfiniteMath.modf(Num)
	Num = checkNumber(Num)
	local sign = InfiniteMath.sign(Num)
	Num *= sign

	local first, second = fixNumber(table.unpack(Num.val:split(',')))
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

		return InfiniteMath.new(`{first},{second}`) * sign, decimal
	end

	return Num
end

return InfiniteMath
