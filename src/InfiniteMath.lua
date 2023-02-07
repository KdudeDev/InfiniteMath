local Number = {

}
Number.__index = Number

----- Private variables -----
local THRESHOLD = 10

local suffixes = require(script.Suffixes)
local full_names = require(script.FullNames)

local numberPrecision = 3 -- How many digits after the decimal point to show

----- Private functions -----
local function fixNumber(first, second)
	first = tonumber(first)
	second = tonumber(second)

	if first == 0 or (second == 0 and first < 1) then
		return first, 0
	elseif second == 0 and first == 0 then
		return 0,0
	else
		local x = math.abs(first)
		local sign = if first < 0 then -1 else 1

		if math.floor(math.log10(x)) ~= 0 then -- Check if exponent is 0 then
			second += math.floor(math.log10(x))
			x /= 10^math.floor(math.log10(x))
		end
		return x*sign, second
	end
end

local function convert(number)
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

local function checkNumbers(a, b)
	if typeof(a) == 'number' then
		a = Number.new(convert(a))
	end

	if typeof(b) == 'number' then
		b = Number.new(convert(b))
	end

	return a, b
end

-- math metamethods:
function Number.__add(a, b)
	a, b =  checkNumbers(a, b)

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))
	if math.abs(second1 - second2) > THRESHOLD then -- Check if difference in exponents is greater than threshold
		if math.max(second1, second2) == second1 then
			return Number.new(`{first1},{second1}`)
		end

		return Number.new(`{first2},{second2}`)
	end

	local difference = second1 - second2
	first2 *= (10^-difference)

	first1, second1 = fixNumber(first1 + first2, second1)

	return Number.new(`{first1},{second1}`)
end

function Number.__sub(a, b)
	a, b =  checkNumbers(a, b)

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))
	if math.abs(second1 - second2) > THRESHOLD then -- Check if difference in exponents is greater than threshold
		if math.max(second1, second2) == second1 then
			return Number.new(`{first1},{second1}`)
		end

		return Number.new(`{first2},{second2}`)
	end

	local difference = second1 - second2
	first2 *= (10^-difference)

	first1, second1 = fixNumber(first1 - first2, second1)
	return Number.new(`{first1},{second1}`)
end

function Number.__mul(a, b)
	a, b =  checkNumbers(a, b)

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	first1, second1 = fixNumber(first1 * first2, second1 + second2)

	return Number.new(`{first1},{second1}`)
end

function Number.__div(a, b)
	a, b =  checkNumbers(a, b)

	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	first1, second1 = fixNumber(first1/first2, second1 - second2)

	return Number.new(`{first1},{second1}`)
end

function Number.__pow(a, power)
	local first, second = fixNumber(table.unpack(a.val:split(',')))
	
	if typeof(power) ~= "number" then
		power = power:Reverse()
	end
	
	local answer = 1
	
	if power > 1 then
		while power > 0 do
			local lastBit = (bit32.band(power, 1) == 1)
			
			if lastBit then
				answer *= first
			end
			
			first *= first
			
			power = bit32.rshift(power, 1)
		end
	elseif power == 0 then
		first, second = 1, 0
	end

	first, second = fixNumber(answer, second)
	return Number.new(`{first},{second}`)
end

function Number.__eq(a, b)
	return a.val == b.val
end

function Number.__lt(a, b)
	a, b =  checkNumbers(a, b)
	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	if second1 == second2 then
		return first1 < first2
	end

	return second1 < second2 and first1 >= 0
end

function Number.__le(a, b)
	a, b =  checkNumbers(a, b)
	local first1, second1 = fixNumber(table.unpack(a.val:split(',')))
	local first2, second2 = fixNumber(table.unpack(b.val:split(',')))

	if second1 == second2 then
		return first1 <= first2
	end

	return second1 < second2 and first1 >= 0
end

function Number.__tostring(self)
	return self:GetSuffix(true)
end

---- Class methods -----
function Number.new(val)
	-- fix up val for evaluation
	if typeof(val) ~= 'string' or #val:split(',') ~= 2 then
		val = convert(val)
	end

	return setmetatable({
		val = val
	}, Number)
end

function Number:GetZeroes()
	return self.val:split(',')[2]
end

function Number:Reverse()
	self.val = self.val:gsub(" ", "")
	local numbers = self.val:split(',')
	return tonumber(numbers[1].."e+"..numbers[2])
end

function Number:ScientificNotation()
	local numbers =  self.val:split(',')
	local first, second = numbers[1], numbers[2]

	return numbers[first]:sub(0, numberPrecision + 1).."e+"..numbers[second] -- Add 1 to numberPrecision to account for the decimal point
end

function Number:GetSuffix(abbreviation)
	if abbreviation == nil then abbreviation = true end

	local numbers = self.val:split(',')
	local first, second = numbers[1], numbers[2]

	first = tonumber(first)
	second = tonumber(second)

	local secondRemainder = second % 3
	first *= 10^secondRemainder

	local suffixIndex = math.floor(second/3)
	local str = math.floor(first * 10)/10

	local suffix = if abbreviation then suffixes[suffixIndex] else (full_names[suffixIndex] and " " .. full_names[suffixIndex] or nil)

	if suffixIndex > 0 then
		str ..= suffix or "e+"..second
	end

	return str
end

function Number.ChangePrecision(n) 
	numberPrecision = n
end

return Number
