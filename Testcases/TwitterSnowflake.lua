-- Unit tests for [[Module:TwitterSnowflake]]. Click talk page to run tests. 
local p = require('Module:UnitTests')

-- test snowflakeToDate

function p:test_snowflakeToDate_only_id() -- default date format is "Month Day, Year"
    self:preprocess_equals('{{#invoke:TwitterSnowflake | snowflakeToDate | id_str = 1345021162959503360}}', 'January  1, 2021')
end

function p:test_snowflakeToDate_custom_output_format() -- tests date format "Day Month Year"
    self:preprocess_equals('{{#invoke:TwitterSnowflake | snowflakeToDate | id_str = 1345021162959503360 | format = %e %B %Y}}', ' 1 January 2021')
end

function p:test_snowflakeToDate_custom_epoch() -- uses Discord's epoch
    self:preprocess_equals('{{#invoke:TwitterSnowflake | snowflakeToDate | id_str = 797545051047460888 | epoch = 1420070400}}', 'January  9, 2021')
end

function p:test_snowflakeToDate_weird_breaking_date() -- this one used to break old versions of the script, outputting "April 11, 2011"
    self:preprocess_equals('{{#invoke:TwitterSnowflake | snowflakeToDate | id_str = 574608900537761792}}', 'March  8, 2015')
end

-- test getDate

function p:test_getDate_date_off_by_five() -- date off by five days, so this returns "5"
    self:preprocess_equals('{{#invoke:TwitterSnowflake | getDate | id_str = 1345021162959503360 | date = January 6, 2021}}', '5')
end

function p:test_getDate_date_off_by_one() -- date off by one day, so this returns "1"
    self:preprocess_equals('{{#invoke:TwitterSnowflake | getDate | id_str = 1345021162959503360 | date = January 2, 2021}}', '1')
end

function p:test_getDate_date_match() -- date matches, so this returns "0"
    self:preprocess_equals('{{#invoke:TwitterSnowflake | getDate | id_str = 1345021162959503360 | date = January 1, 2021}}', '0')
end

function p:test_getDate_before_epoch() -- posted before epoch, so this returns "-1" (date isn't correct here, but that's irrelevant — it can't check it either way)
    self:preprocess_equals('{{#invoke:TwitterSnowflake | getDate | id_str = 20 | date = January 1, 2015}}', '-1')
end

function p:test_getDate_invalid_id_str() -- id_str is invalid, so this returns "-2"
    self:preprocess_equals('{{#invoke:TwitterSnowflake | getDate | id_str = 1345021162959503360?s=19 | date = January 1, 2021}}', '-2')
end

--sandbox tests for snowflakeToDate

function p:test_zzsandbox_snowflakeToDate_only_id() -- default date format is "Month Day, Year"
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | snowflakeToDate | id_str = 1345021162959503360}}', 'January  1, 2021')
end

function p:test_zzsandbox_snowflakeToDate_custom_output_format() -- tests date format "Day Month Year"
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | snowflakeToDate | id_str = 1345021162959503360 | format = %e %B %Y}}', ' 1 January 2021')
end

function p:test_zzsandbox_snowflakeToDate_custom_epoch() -- uses Discord's epoch
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | snowflakeToDate | id_str = 797545051047460888 | epoch = 1420070400}}', 'January  9, 2021')
end

function p:test_zzsandbox_snowflakeToDate_weird_breaking_date() -- this one used to break old versions of the script, outputting "April 11, 2011"
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | snowflakeToDate | id_str = 574608900537761792}}', 'March  8, 2015')
end

--sandbox tests for getDate

function p:test_zzsandbox_getDate_date_off_by_five() -- date off by five days, so this returns "5"
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | getDate | id_str = 1345021162959503360 | date = January 6, 2021}}', '5')
end

function p:test_zzsandbox_getDate_date_off_by_one() -- date off by one day, so this returns "1"
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | getDate | id_str = 1345021162959503360 | date = January 2, 2021}}', '1')
end

function p:test_zzsandbox_getDate_date_match() -- date matches, so this returns "0"
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | getDate | id_str = 1345021162959503360 | date = January 1, 2021}}', '0')
end

function p:test_zzsandbox_getDate_before_epoch() -- posted before epoch, so this returns "-1" (date isn't correct here, but that's irrelevant — it can't check it either way)
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | getDate | id_str = 20 | date = January 1, 2015}}', '-1')
end

function p:test_zzsandbox_getDate_invalid_id_str() -- id_str is invalid, so this returns "-2"
    self:preprocess_equals('{{#invoke:TwitterSnowflake/sandbox | getDate | id_str = 1345021162959503360?s=19 | date = January 1, 2021}}', '-2')
end

return p