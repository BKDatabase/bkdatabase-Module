-- Unit tests for [[Module:IPAddress]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_isIp()
    self:preprocess_equals_many('{{#invoke:IPAddress/sandbox|isIp|', '}}', {
        {'200.200.200.200', '4'},
        {' 200.200.200.200', ''}, -- whitespace not currently allowed
        {'200.200.200.200 ', ''}, -- whitespace not currently allowed
        {'200.200.256.200', ''},
        {'200.200.200.200.', ''},
        {'200.200.200', ''},
        {'200.200.200.2d0', ''},
        {'0.0.0.0', '4'},
        {'00.00.00.00', ''}, -- according to talkpage, leading zeroes unacceptable.
        {'100.100.020.100', ''}, -- according to talkpage, leading zeroes unacceptable.
        {'255.255.255.255', '4'},
        {'-1.0.0.0', ''},
        {'200000000000000000000000000000000000000000000000000000000000000000000000000000.200.200.200', ''},
        {'00000000000005.10.10.10', ''},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD', '6'}, -- full length
        {'00ab:0002:3008:8cfd:00ab:0002:3008:8cfd', '6'}, -- lowercase
        {'00aB:0002:3008:8cFd:00Ab:0002:3008:8cfD', '6'}, -- mixed case
        {'00AB:00002:3008:8CFD:00AB:0002:3008:8CFD', ''}, -- at most 4 digits per segment
        {':0002:3008:8CFD:00AB:0002:3008:8CFD', ''}, -- can't remove all 0s from first segment unless using ::
        {'00AB:0002:3008:8CFD:00AB:0002:3008:', ''}, -- can't remove all 0s from last segment unless using ::
        {'AB:02:3008:8CFD:AB:02:3008:8CFD', '6'}, -- abbreviated
        {'AB:02:3008:8CFD:AB:02:3008:8CFD:02', ''}, -- too long
        {'AB:02:3008:8CFD::02:3008:8CFD', '6'}, -- correct use of ::
        {'AB:02:3008:8CFD::02:3008:8CFD:02', ''}, -- too long
        {'AB:02:3008:8CFD::02::8CFD', ''}, -- can't have two ::s
        {'GB:02:3008:8CFD:AB:02:3008:8CFD', ''}, -- Invalid character G
        {'::', '6'}, -- unassigned IPv6 address
        {'::1', '6'}, -- loopback IPv6 address
        {'0::', '6'}, -- another name for unassigned IPv6 address
        {'0::0', '6'}, -- another name for unassigned IPv6 address
        {'2:::3', ''}, -- illegal: three colons
    })
end

function p:test_isIpV4Range()
    self:preprocess_equals_many('{{#invoke:IPAddress/sandbox|isIpV4Range|', '}}', {
        {'200.200.200.200', '0'},
        {'200.200.200.0/28', '1'},
        {'0.0.0.0', '0'},
        {'0.0.0.0/28', '1'},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD', '0'},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD/64', '0'},
        {'0::0/64', '0'}, 
        {'0::0', '0'}, 
    })
end

function p:test_isIpV6Range()
    self:preprocess_equals_many('{{#invoke:IPAddress/sandbox|isIpV6Range|', '}}', {
        {'200.200.200.200', '0'},
        {'200.200.200.0/24', '0'},
        {'0.0.0.0', '0'},
        {'0.0.0.0/24', '0'},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD', '0'},
        {'00AB:0002:3008:8CFD::/64', '1'},
        {'0::0/64', '1'}, 
        {'0::0', '0'}, 
    })
end

function p:test_temp_user()
    self:preprocess_equals_many('{{#invoke:IPAddress/sandbox|isTempUser|', '}}', {
        {'200.200.200.200', '0'},
        {'200.200.200.0/24', '0'},
        {'0.0.0.0', '0'},
        {'0.0.0.0/24', '0'},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD', '0'},
        {'00AB:0002:3008:8CFD::/64', '0'},
        {'0::0/64', '0'}, 
        {'0::0', '0'}, 
        {'~2025-12345-67', '1'},
        {'2025-12345-67', '0'},
        {'Example', '0'}
    })
end

function p:test_perm_user()
    self:preprocess_equals_many('{{#invoke:IPAddress/sandbox|isPermUser|', '}}', {
        {'200.200.200.200', '0'},
        {'200.200.200.0/24', '0'},
        {'0.0.0.0', '0'},
        {'0.0.0.0/24', '0'},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD', '0'},
        {'00AB:0002:3008:8CFD::/64', '0'},
        {'0::0/64', '0'}, 
        {'0::0', '0'}, 
        {'~2025-12345-67', '0'},
        {'2025-12345-67', '1'},
        {'Example', '1'}
    })
end

function p:test_user()
    self:preprocess_equals_many('{{#invoke:IPAddress/sandbox|isUser|', '}}', {
        {'200.200.200.200', ''},
        {'200.200.200.0/24', ''},
        {'0.0.0.0', ''},
        {'0.0.0.0/24', ''},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD', ''},
        {'00AB:0002:3008:8CFD::/64', ''},
        {'0::0/64', ''}, 
        {'0::0', ''}, 
        {'~2025-12345-67', 'temp'},
        {'2025-12345-67', 'perm'},
        {'Example', 'perm'}
    })
end

function p:test_main()
    self:preprocess_equals_many('{{#invoke:IPAddress/sandbox|main|', '}}', {
        {'200.200.200.200', 'ip'},
        {'200.200.200.0/24', 'range'},
        {'0.0.0.0', 'ip'},
        {'0.0.0.0/24', 'range'},
        {'00AB:0002:3008:8CFD:00AB:0002:3008:8CFD', 'ip'},
        {'00AB:0002:3008:8CFD::/64', 'range'},
        {'0::0/64', 'range'}, 
        {'0::0', 'ip'}, 
        {'~2025-12345-67', 'temp'},
        {'2025-12345-67', 'perm'},
        {'Example', 'perm'}
    })
end

return p
