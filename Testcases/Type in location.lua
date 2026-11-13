local p = require('Module:UnitTests')

function p:testMain()
	-- empty
	self:preprocess_equals('{{#invoke:Type in location|generateDesc}}',
		'')
	-- just type
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Airport}}',
		'Airport')
	-- junk type
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|<b></b>}}',
		'')
	-- just location
	self:preprocess_equals('{{#invoke:Type in location|generateDesc||London}}',
		'')
	-- type and location
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Airport|London}}',
		'Airport in London')
	-- type and wlink location
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Airport|[[Dayton, Ohio]]}}',
		'Airport in Dayton, Ohio')
	-- type and complex location
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Radio station|[[Natchitoches, Louisiana]], United States}}',
		'Radio station in Louisiana, United States')
	-- type and complex location with piping
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Radio station|[[Natchitoches, Louisiana|Natchitoches]], [[Louisiana]]}}',
		'Radio station in Natchitoches, Louisiana')
	-- type and very messy location
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Radio station| Special place, Dayton,,   Ohio, ABC123}}',
		'Radio station in Dayton, Ohio')
	-- type and location with flag
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Shopping mall|[[Gateshead]], [[United Kingdom]] }}',
		'Shopping mall in Gateshead, United Kingdom')
	-- type and location with postal code
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|[[Historic house museum]]|Oxford Road, [[Gomersal]], [[West Yorkshire]], England<br/>BD19 4JP}}',
		'Historic house museum in West Yorkshire, England')
	-- check pattern succeeds
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|[[Natural history museum]]|[[Philadelphia]]|check-patterns = [Mm]useum;[Hh]all;[Gg]allery;[Cc]enter}}',
		'Natural history museum in Philadelphia')
	-- check pattern fails
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Historic house|Oxford Road, [[Gomersal]], [[West Yorkshire]], England<br/>BD19 4JP|check-patterns = [Mm]useum;[Hh]all;[Gg]allery;[Cc]enter}}',
		'')
	-- test lc matching
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Power plant cooling/recreational [[Reservoir (water)|Reservoir]]|Central [[Austin, Texas|Austin]], [[Texas]],<br />[[United States]]|check-patterns=basin;bay;bight;channel;estuary;gulf;lagoon;lake;loch;moraine;ocean;reservoir;river;sea;sound;strait|invalidadd=body of water}}',
		'Power plant cooling/recreational Reservoir in Texas, United States')
	-- test invalidadd
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|[[Geothermal (geology)|geothermal]]|[[Wai-O-Tapu| Waiotapu]], [[North Island]]|check-patterns=basin;bay;bight;channel;estuary;gulf;lagoon;lake;loch;moraine;ocean;reservoir;river;sea;sound;strait|invalidadd=body of water}}',
		'Geothermal body of water in Waiotapu, North Island')
    -- ubl location
	self:preprocess_equals('{{#invoke:Type in location|generateDesc|Bridge|{{ublist|[[Dandong]], [[Liaoning]], China|[[Sinŭiju]], [[North P\'yŏngan]], North Korea}}}}',
         'Bridge')
end


function p:testSandbox()
	-- empty
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc}}',
		'')
	-- just type
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Airport}}',
		'Airport')
	-- junk type
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|<b></b>}}',
		'')
	-- just location
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc||London}}',
		'')
	-- type and location
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Airport|London}}',
		'Airport in London')
	-- type and wlink location
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Airport|[[Dayton, Ohio]]}}',
		'Airport in Dayton, Ohio')
	-- type and complex location
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Radio station|[[Natchitoches, Louisiana]], United States}}',
		'Radio station in Louisiana, United States')
	-- type and complex location with piping
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Radio station|[[Natchitoches, Louisiana|Natchitoches]], [[Louisiana]]}}',
		'Radio station in Natchitoches, Louisiana')
	-- type and very messy location
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Radio station| Special place, Dayton,,   Ohio, ABC123}}',
		'Radio station in Dayton, Ohio')
	-- type and location with flag
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Shopping mall|[[Gateshead]], [[United Kingdom]]}}',
		'Shopping mall in Gateshead, United Kingdom')
	-- type and location with postal code
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|[[Historic house museum]]|Oxford Road, [[Gomersal]], [[West Yorkshire]], England<br/>BD19 4JP}}',
		'Historic house museum in West Yorkshire, England')
	-- check pattern succeeds
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|[[Natural history museum]]|[[Philadelphia]]|check-patterns = [Mm]useum;[Hh]all;[Gg]allery;[Cc]enter}}',
		'Natural history museum in Philadelphia')
	-- check pattern fails
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Historic house|Oxford Road, [[Gomersal]], [[West Yorkshire]], England<br/>BD19 4JP|check-patterns = [Mm]useum;[Hh]all;[Gg]allery;[Cc]enter}}',
		'')
	-- test lc matching
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Power plant cooling/recreational [[Reservoir (water)|Reservoir]]|Central [[Austin, Texas|Austin]], [[Texas]],<br />[[United States]]|check-patterns=basin;bay;bight;channel;estuary;gulf;lagoon;lake;loch;moraine;ocean;reservoir;river;sea;sound;strait|invalidadd=body of water}}',
		'Power plant cooling/recreational Reservoir in Texas, United States')
	-- test invalidadd
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|[[Geothermal (geology)|geothermal]]|[[Wai-O-Tapu| Waiotapu]], [[North Island]]|check-patterns=basin;bay;bight;channel;estuary;gulf;lagoon;lake;loch;moraine;ocean;reservoir;river;sea;sound;strait|invalidadd=body of water}}',
		'Geothermal body of water in Waiotapu, North Island')
	-- ubl location
	self:preprocess_equals('{{#invoke:Type in location/sandbox|generateDesc|Bridge|{{ublist|[[Dandong]], [[Liaoning]], China|[[Sinŭiju]], [[North P\'yŏngan]], North Korea}}}}',
         'Bridge')
end

return p