function main()

--[[ Enforce Response Status ]] 
EnforceResponseCode()

--[[ Enforce Response Title ]]
EnforceResponseTitle()

--[[ Enforce Response Size ]]
EnforceResponseSize()

--[[ Enforce Page Scripts ]]
EnforceNumOfScripts()



m.log(4, "Ending Response Profile Enforcer Script")
return nil
end

function EnforceNumOfScripts()
	local response_body = m.getvar("RESPONSE_BODY", "lowercase");

        -- if response_body ~= "" then
        local _, nscripts = string.gsub(response_body, "<script", "");

                if nscripts == nil then
                        nscripts = 0
                end

        -- end

        local NumOfScripts = tonumber(nscripts)
	local MinNumOfScripts = tonumber(m.getvar("RESOURCE.MinNumOfScripts", {"none"}))
	local MaxNumOfScripts = tonumber(m.getvar("RESOURCE.MaxNumOfScripts", {"none"}))
      	local EnforceNumOfScripts = m.getvar("RESOURCE.enforce_num_of_scripts")

	if NumOfScripts == MaxNumOfScripts then
		m.log(4, "Number of SCRIPTS is consistent.")
	elseif ((NumOfScripts > MinNumOfScripts) and (NumOfScripts < MaxNumOfScripts)) then
		m.log(4, "Number of SCRIPTS is within normal range.")
	elseif NumOfScripts < MinNumOfScripts then
               	m.log(4, "Number of SCRIPTS is less than MinNumOfScripts: " .. MinNumOfScripts .. ".")
		m.setvar("TX.MIN_NUM_SCRIPTS_VIOLATION", "1")
		m.setvar("TX.NUM_OF_SCRIPTS", NumOfScripts)
	elseif NumOfScripts > MaxNumOfScripts then
		m.log(4, "Number of SCRIPTS is more than MaxNumOfScripts: " .. MaxNumOfScripts .. ".")
                m.setvar("TX.MAX_NUM_SCRIPTS_VIOLATION", "1")
		m.setvar("TX.NUM_OF_SCRIPTS", NumOfScripts)
       	end
end


function EnforceResponseSize()
	local ResponseSize = m.getvar("RESPONSE_BODY", {"length"})
        ResponseSize = tonumber(ResponseSize)
	m.log(4, "Response Size: " ..ResponseSize.. ".")

	local MinResponseSize = tonumber(m.getvar("RESOURCE.MinResponseSize", {"none"}))
	local MaxResponseSize = tonumber(m.getvar("RESOURCE.MaxResponseSize", {"none"}))
      	local EnforceResponseSize = m.getvar("RESOURCE.enforce_response_size")

	m.log(4, "Response Size: " ..ResponseSize.. ", MinResponseSize: " ..MinResponseSize.. ", MaxResponseSize: " ..MaxResponseSize.. ".")

	if ResponseSize == MaxResponseSize then
                m.log(4, "Response Size is consistent.")
	elseif ((ResponseSize > MinResponseSize) and (ResponseSize < MaxResponseSize)) then
		m.log(4, "Response Size is within normal range.")
	elseif ResponseSize < MinResponseSize then
               	m.log(4, "Response Size is less than MinResponseSize: " .. MinResponseSize .. ".")
		m.setvar("TX.MIN_RESPONSE_SIZE_VIOLATION", ResponseSize)
	elseif ResponseSize > MaxResponseSize then
		m.log(4, "Response Size is more than MaxResponseSize: " .. MaxResponseSize .. ".")
                m.setvar("TX.MAX_RESPONSE_SIZE_VIOLATION", ResponseSize)
       	end
end


function EnforceResponseTitle()
        local ResponseTitle = m.getvar("RESPONSE_BODY", {"lowercase"})
	ResponseTitle = string.gsub(ResponseTitle, ".*<title>(.+)</title>.*", "%1")

        local EnforceResponseTitle = m.getvar("RESOURCE.enforce_response_title")
        local EnforceResponseTitleMatch = string.find(EnforceResponseTitle, ResponseTitle)
                if (EnforceResponseTitleMatch) then
                        m.log(4, "Response Title: " .. ResponseTitle .. " already in Enforcement List.")
                else
                        m.log(4, "Response Title: " .. ResponseTitle .. " profile violation.")
                        m.setvar("TX.response_title_violation", ResponseTitle)

                end

end


function EnforceResponseCode()
        local ResponseCode = m.getvar("RESPONSE_STATUS", {"none"})

        local EnforceResponseCode = m.getvar("RESOURCE.enforce_response_code")
        local EnforceResponseCodeMatch = string.find(EnforceResponseCode, ResponseCode)
                if (EnforceResponseCodeMatch) then
                        m.log(4, "Response Code: " .. ResponseCode .. " already in Enforcement List.")
                else
                        m.log(4, "Response Code: " .. ResponseCode .. " profile violation.")
                        m.setvar("TX.response_code_violation", "1")
        
                end

end
