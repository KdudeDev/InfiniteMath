local Number = {
	
}
Number.__index = Number

----- Private variables -----
local THRESHOLD = 10
local suffixes = {'K','M','B','T','Q','QN','S','SP','O','N','D','UD','DD','TD','QD','QND','SD','SPD','OD','ND','V','UV','DV','TV','QV','QNT','SV','SPV','OV','NV','TG','UTG','DTG','TTG','QTG','QNTG','STG','SPTG','OTG','NTG','QG','UQG','DQG','TQG','QQG','QNQG','SQG','SPQG','OQG','NQG','QQ','UQQ','DQQ','TQQ','QQQ','QNQQ','SQQ','SPQQ','OQQ','NQQ','SX','USX','DSX','TSX','QSX','QNSX','SSX','SPSX','OSX','NSX','SG','USG','DSG','TSG','QSG','QNSG','SSG','SPSG','OSG','NSG','OG','UOG','DOG','TOG','QOG','QNOG','SOG','SPOG','OOG','OOG','NOG','NG','UNG','DNG','TNG','QNG','QNNG','SNG','SPNG','ONG','NNG','C','UC','DC','TC','QC','QNC','SC','SPC','OC','NC','DN','UDN','DDN','TDN','QDN','QNDN','SDN','SPDN','ODN','NDN','VC','UVC','DVC','TVC','QVC','QNVC','SVC','SPVC','OVC','NVC','TN','UTN','DTN','TTN','QTN','QNTN','STN','SPTN','OTN','NTN','QT','UQT','DQT','TQT','QQT','QNQT','SQT','SPQT','OQT','NQT','QL','UQL','DQL','TQL','QQL','QNQL','SQL','SPQL','OQL','NQL','SN','USN','DSN','TSN','QSN','QNSN','SSN','SPSN','OSN','NSN','ST','UST','DST','TST','QST','QNST','SST','SPST','OST','NST','ON','UON','DON','TON','QON','QNON','SON','SPON','OON','NON','NN','UNN','DNN','TNN','QNN','QNNN','SNN','SPNN','ONN','NNN','DT','UDT','DDT','TDT','QDT','QNDT','SDT','SPDT','ODT','NDT','DL','UDL','DDL','TDL','QDL','QNDL','SDL','SPDL','ODL','NDL','VD','UVD','DVD','TVD','QVD','QNVD','SVD','SPVD','OVD','NVD','TT','UTT','DTT','TTT','QTT','QNTT','STT','SPTT','OTT','NTT','QU','UQU','DQU','TQU','QQU','QNQU','SQU','SPQU','OQU','NQU','QI','UQI','DQI','TQI','QQI','QNQI','SQI','SPQI','OQI','NQI','SL','USL','DSL','TSL','QSL','QNSL','SSL','SPSL','OSL','NSL','SE','USE','DSE','TSE','QSE','QNSE','SSE','SPSE','OSE','NSE','OT','UOT','DOT','TOT','QOT','QNOT','SOT','SPOT','OOT','NOT','NT','UNT','DNT','TNT','QNT','QNNT','SNT','SPNT','ONT','NNT','TR','UTR','DTR','TTR','QTR','QNTR','STR','SPTR','OTR','NTR','DR','UDR','DDR','TDR','QDR','QNDR','SDR','SPDR','ODR','NDR','VT','UVT','DVT','TVT','QVT','QNVT','SVT','SPVT','OVT','NVT','TL','UTL','DTL','TTL','QTL','QNTL','STL','SPTL','OTL','NTL','QA','UQA','DQA','TQA','QQA','QNQA','SQA','SPQA','OQA','NQA','QE','UQE','DQE','TQE','QQE','QNQE','SQE','SPQE','OQE','NQE','SR','USR','DSR','TSR','QSR','QNSR','SSR','SPSR','OSR','NSR','SU','USU','DSU','TSU','QSU','QNSU','SSU','SPSU','OSU','NSU','OR','UOR','DOR','TOR','QOR','QNOR','SOR','SPOR','OOR','NOR','NR','UNR','DNR','TNR','QNR','QNNR','SNR','SPNR','ONR','NNR','QR','UQR','DQR','TQR','QQR','QNQR','SQR','SPQR','OQR','NQR','DQ','UDQ','DDQ','TDQ','QDQ','QNDQ','SDQ','SPDQ','ODQ','NDQ','VQ','UVQ','DVQ','TVQ','QVQ','QNVQ','SVQ','SPVQ','OVQ','NVQ','TQ','UTQ','DTQ','TTQ','QTQ','QNTQ','STQ','SPTQ','OTQ','NTQ','QO','UQO','DQO','TQO','QQO','QNQO','SQO','SPQO','OQO','SQO','QQS','UQQD','DQQD','TQQD','QQQD','QNQQD','SQQD','SPQQD','OQQD','NQQD','SQ','USQ','DSQ','TSQ','QSE','QNSQ','SSQ','SPSQ','OSQ','NSQ','SA','USA','DSA','TSA','QSA','QNSA','SSA','SPSA','OSA','NSA','OQ','UOQ','DOQ','TOQ','QOQ','QNOQ','SOQ','SPOQ','OOQ','NOQ','NQ','UNQ','DNQ','TNQ','QNQ','QNNQ','SNQ','SPNQ','ONQ','NNQ','QGN','UQGN','DQGN','TQGN','QQGN','QNQGN','SQGN','SPQGN','OQGN','NQGN','DG','UDG','DDG','TDG','QDG','QNDG','SDG','SPDG','ODG','NDG','VG','UVG','DVG','TVG','QVG','QNVG','SVG','SPVG','OVG','NVG','TI','UTI','DTI','TTI','QTI','QNTI','STI','SPTI','OTI','NTI','QDO','UQDQ','DQDQ','TQDQ','QQDQ','QNQDQ','SQDQ','SPQDQ','OQDQ','NQDQ','QGQ','UQGQ','DQGQ','TQGQ','QQGQ','QNQGQ','SQGQ','SPQGQ','OQGQ','NQGQ','SI','USI','DSI','TSI','QSI','QNSI','SSI','SPSI','OSI','NSI','SO','USO','DSO','TSO','QSO','QNSO','SSO','SPSO','OSO','NSO','OL','UOL','DOL','TOL','QOL','QNOL','SOL','SPOL','OOL','NOL','NL','UNL','DNL','TNL','QNL','QNNL','SNL','SPNL','ONL','NNL','SS','USS','DSS','TSS','QSS','QNSS','SSS','SPSS','OSS','NSS','DS','UDS','DDS','TDS','QDS','QNDS','ODS','NDS','VS','UVS','DVS','TVS','QVS','QNVS','SVS','SPVS','OVS','NVS','TS','UTS','DTS','TTS','QTS','QNTS','STS','SPTS','OTS','NTS','QS','UQS','DQS','TQS','QQS','QNQS','SQS','SPQS','OQS','NQS','QGS','UQGS','DQGS','TQGS','QQGS','QNQGS','SQGS','SPQGS','OQGS','NQGS','SXS','USXS','DSXS','TSXS','QSXS','QNSXS','SSXS','SPSXS','OSXS','NSXS','SPS','USPS','DSPS','TSPS','QSPS','QNSPS','SSPS','SPSPS','OSPS','NSPS','OS','UOS','DOS','TOS','QOS','QNOS','SOS','SPOS','OOS','NOS','NS','UNS','DNS','TNS','QNS','QNNS','SNS','SPNS','ONS','NNS','SPG','USPG','DSPG','TSPG','QSPG','QNSPG','SSPG','SPSPG','OSPG','NSPG','DP','UDP','DDP','TDP','QDP','QNDP','SDP','SPDP','ODP','NDP','VP','UVP','DVP','TVP','OVP','QNVP','SVP','SPVP','OVP','NVP','TP','UTP','DTP','TTP','QTP','QNTP','STP','SPTP','OTP','NTP','QP','UQP','DQP','TQP','QQP','QNQP','SQP','SPQP','OQP','NQP','QGP','UQGP','DQGP','QQGP','QNQGP','SQGP','SPQGP','OQGP','NQGP','SGS','USGS','DSGS','TSGS','QSGS','QNSGS','SSGS','SPSGS','OSGS','NSGS','SSP','USSP','DSSP','TSSP','QSSP','QNSSP','SSSP','SPSSP','OSSP','NSSP','OP','UOP','DOP','TOP','QOP','QNOP','SPOP','OOP','NOP','NP','UNP','DNP','TNP','QNP','QNNP','SNP','SPNP','ONP','NNP','OI','UOI','DOI','TOI','QOI','QNOI','SOI','SPOI','OOI','NOI','DO','UDO','DDO','TDO','QDO','QNDO','SDO','SPDO','ODO','NDO','VO','UVO','DVO','TVO','QVO','QNVO','SVO','SPVO','OVO','NVO','TO','UTO','DTO','TTO','QTO','QNTO','STO','SPTO','OTO','NTO','QGO','UQGO','DQGO','TQGO','QQGO','QNQGO','SQGO','SPQGO','OQGO','NQGO','QOC','UQOC','DQOC','TQOC','QQOC','QNQOC','SQOC','SPQOC','OQOC','NQOC','SXO','USXO','DSXO','TSXO','QSXO','QNSXO','SSXO','SPSXO','OSXO','NSXO','SPO','USPO','DSPO','TSPO','QSPO','QNSPO','SSPO','SPSPO','OSPO','NSPO','OO','UOO','DOO','TOO','QOO','QNOO','SOO','SPOO','OOO','NOO','NO','UNO','DNO','TNO','QNO','QNNO','SNO','SPNO','ONO','NNO','NE','UNE','DNE','TNE','QNE','QNNE','SNE','SPNE','ONE','NNE','DE','UDE','DDE','TDE','QDE','QNDE','SDE','SPDE','ODE','NDE','VN','UVN','DVN','TVN','QVN','QNVN','SVN','SPVN','OVN','NVN','TE','UTE','DTE','TTE','QTE','QNTE','STE','SPTE','OTE','NTE','QGG','UQGG','DQGG','TQGG','QQGG','QNQGG','SQGG','SPQGG','OQGG','NQGG','QQN','UQQN','DQQN','TQQN','QQQN','QNQQN','SQQN','SPQQN','OQQN','NQQN','SXN','USXN','DSXN','TSXN','QSXN','QNSXN','SSXN','SPXN','OSXN','NSXN','SPN','USPN','DSPN','TSPN','OSPN','QNSPN','SSPN','SPSPN','OSPN','NSPN','OE','UOE','DOE','TOE','QOE','QNOE','SOE','SPOE','OOE','NOE','NA','UNA','DNA','TNA','QNA','QNNA','SNA','SPNA','ONA','NNA','MN','MM','MB','MT','MQ','MQN','MS','MSP','MO','MNN','MD','MUD','MDD','MTD','MQD','MQND','MSD','MSPD','MOD','MND','MV','MUV','MDV','MTV','MQV','MQNT','MSV','MSPV','MOV','MNV','MTG'}

----- Private functions -----
local function fixNumber(first, second)
	first = tonumber(first)
	second = tonumber(second)
	
	if first == 0 then
		return first, 0
	elseif second < 0 then
		local sign = if first < 0 then -1 else 1
		
		local x = math.abs(first)

		if second > -4 then
			for i = 1, math.abs(second) do
				x /= 10
				second += 1
			end
		else
			for i = 1, 4 do
				x /= 10
				second += 1
			end
		end

		x *= sign

		return x, 0
		
	elseif second == 0 and first < 1 then
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
	
	local first
	local second = #numberStr - 1
	
	if numberStr:match("e") then
		second = numberStr:split("+")[2]
		first = numberStr:split("e")[1]
	elseif numberStr:match("inf") then
		second = "inf"
		first = "inf"
	elseif numberStr:match("nan") then
		second = "nan"
		first = "nan"
	elseif second >= 1 then
		first = numberStr:sub(1, 1).."."..numberStr:sub(2, THRESHOLD)
	else
		first = number
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

-- TODO: make this compatible with other numbers of class 'Number'
function Number.__pow(a, power)
	local first, second = fixNumber(table.unpack(a.val:split(',')))
	
	if power > 1 then
		local orig = first
		for i = 1, power do
			first *= orig
		end
		second *= power
	end
	
	first, second = fixNumber(first, second)
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
	local numbers =  self.val:split(',')
	return math.floor(numbers[1].."e+"..numbers[2])
end

function Number:ScientificNotation()
	local numbers =  self.val:split(',')
	local first, second = numbers[1], numbers[2]

	return numbers[1]:sub(0, 4).."e+"..numbers[2]
end

function Number:GetSuffix()
	local numbers =  self.val:split(',')
	local first, second = numbers[1], numbers[2]

	if second ~= 0 then
		first, second = fixNumber(first, second)
	end

	local stringed = nil

	if second == 0 then
		if #first > 5 then
			repeat
				first = first:sub(0, -2)
			until #first <= 5
		end

		local firsts = first:split(".")

		if firsts[2] ~= nil then
			stringed = firsts[1].."."..firsts[2]
		else
			stringed = first
		end
	elseif second == 1 or second == -1 then
		local firsts = first:split(".")

		if firsts[2] ~= nil then
			local firstsub = firsts[2]:sub(0, 1)
			stringed = firsts[1]..firstsub
		else
			stringed = first.."0"
		end
	elseif second == 2 or second == -2 then
		local firsts = first:split(".")

		if firsts[2] ~= nil then
			local firstsub = firsts[2]:split(0, 2)
			local secondsub = string.sub(firsts[2], 2)
			stringed = firsts[1]..firstsub
			
			if #secondsub == 0 then
				stringed ..= "0"
			end
		else
			stringed = first.."00"
		end
	else
		if string.len(tostring(first)) > 5 then
			repeat
				first = tonumber(tostring(first):sub(0, -2))
			until string.len(tostring(first)) <= 5
		end

		local chosen = suffixes[math.floor(second / 3)]

		if chosen ~= nil then
			local firsts = string.split(first, ".")

			if firsts[2] ~= nil then
				if string.len(firsts[2]) > 3 then
					repeat
						firsts[2] = tonumber(tostring(firsts[2]):sub(0, -2))
					until string.len(firsts[2]) <= 3
				end
			end

			if second / 3 == math.floor(second / 3) then
				if firsts[2] ~= nil then
					local firstsub = string.sub(firsts[2], 0, 3)
					if string.len(firstsub) == 0 then
						stringed = firsts[1]..chosen
					else
						stringed = firsts[1].."."..firstsub..chosen
					end
				else
					stringed = first..""..chosen
				end
			elseif (second + 1) / 3 == math.floor((second + 1) / 3) then
				if firsts[2] ~= nil then
					local firstsub = string.sub(firsts[2], 0, 2)
					local secondsub = string.sub(firsts[2], 2)
					if string.len(secondsub) == 0 then
						stringed = firsts[1]..firstsub.."0"..chosen
					elseif string.len(secondsub) == 2 then
						stringed = firsts[1]..firstsub.."."..secondsub..chosen
					else
						stringed = firsts[1]..firstsub.."."..secondsub..chosen
					end
				else
					if string.len(firsts[1]) == 1 then
						stringed = first.."00"..chosen
					else
						stringed = first.."0"..chosen
					end
				end
			elseif (second + 2) / 3 == math.floor((second + 2) / 3) then
				if firsts[2] ~= nil then
					local firstsub = string.sub(firsts[2], 0, 1)
					local secondsub = string.sub(firsts[2], 2)
					if string.len(secondsub) == 0 then
						stringed = firsts[1]..firstsub..chosen
					else
						stringed = firsts[1]..firstsub.."."..secondsub..chosen
					end
				else
					if string.len(firsts[1]) == 1 then
						stringed = first.."0"..chosen
					else
						stringed = first..""..chosen
					end
				end
			end
		end
	end

	if stringed == nil then
		local firstsub = string.sub(first, 0, 4)
		stringed = firstsub.."e+"..second
	end

	return stringed
end

return Number
