-----------------------------------------------------------------------------
-- c8y_date: for Cumulocity date management.
-- Author: www.DoNovae.com - Herve BAILLY
-- Date: Frebruary 2014
-- Version: 1.0.0
-- This module is released under the GPL License
-----------------------------------------------------------------------------

require 'os'
require 'uci'
local xx=uci.cursor()

c8y_date={}

function c8y_date.get()
  local dt
  local tmz=''
  local ret=''
  --TBD
  --local timezone=xx:get('system','system','timezone')
  --if (timezone == 'CET-1CEST,M3.5.0,M10.5.0/3') then
    tmz='01:00' 
  --else
    --tmz='02:00' 
  --end
  dt=os.date('*t')
  ret=dt.year..'-'..dt.month..'-'..dt.day..'T'..dt.hour..':'..dt.min..':'..dt.sec..'.000+'..tmz
  return ret
end


return c8y_date
