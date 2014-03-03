-----------------------------------------------------------------------------                                           
-- c8y_alarm: for Cumulocity alarm management.                                                                  
-- Author: www.DoNovae.com - Herve BAILLY                                                                                       
-- Date: Frebruary 2014                                                                                                 
-- Version: 1.0.0                                                                                                             
-- This module is released under the GPL License                                                                              
-----------------------------------------------------------------------------
require 'c8y_date'
require 'c8y_inventory'
local json=require('luci.json')                                                                                                    
require 'c8y_restful'
local debug=true
                                                                                                                                   
c8y_alarm = {
	root ={type='application/vnd.com.nsn.cumulocity.alarmApi+json',resource='/alarm'},
	alarm ={type='application/vnd.com.nsn.cumulocity.alarm+json',resource='/alarm/alarms'},
	alarmcollection ={type='application/vnd.com.nsn.cumulocity.alarmApi+json',resource=''},
	severity={MINOR='MINOR',MAJOR='MAJOR'},
	status={ACKNOWLEDGED='ACKNOWLEDGED',ACTIVE='ACTIVE',CLEARED='CLEARED'}
}

-------------------------                                                                                                                                   
--get_api()                                                                                                                                          
-------------------------                                                                                                                                   
function c8y_alarm.get_api() 
  local ret, code, head
  ret, code, head = c8y_restful.get( c8y_alarm.root.type,c8y_alarm.root.resource )
  if debug then
        c8y_restful.tabledump(ret)
  end
end

-------------------------                                                
--get_alarms()                                                                                                       
-------------------------                                                                                                                   
--@url
-------------------------                                                                                                                   
function c8y_alarm.get_alarms(url)                                                                                           
    local ret
    local ret0={}
    
    if debug then print('c8y_alarm.get_alarms') end
    url=string.gsub(url,'+','%%2B')
                                                                                                                                            
    ret = c8y_restful.get(c8y_alarm.root.type,url)
    if debug and ret then
        c8y_restful.tabledump(ret)
    end
    ret0={ret}
    
    while ret and ret.next and ret.alarms[1] ~= nil do
      if not ( ret and ret.next ) then break end
       print( '-------> ret.next: '..ret.next )
       ret = c8y_restful.get( c8y_alarm.root.type,ret.next )
       if ret.alarms[1] == nil then break end
       if debug and ret then
          c8y_restful.tabledump(ret)
      end
      ret0={ret0,ret}
    end
    return ret0
end

-------------------------
--alarmsForTime()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
-------------------------
function c8y_alarm.alarmsForTime(dateFrom,dateTo)                                                                                           
  local ret
  if debug then print('c8y_alarm.alarmsForTime') end
  url=c8y_alarm.root.resource..'/alarms?dateFrom='..dateFrom..'&dateTo='..dateTo
  ret=c8y_alarm.get_alarms(url)
  return ret
end

-------------------------
--alarmsForSourceAndStatus()                                                                                                       
-------------------------
--@source
--@status
-------------------------
function c8y_alarm.alarmsForSourceAndStatus(source,status)                                                                                           
  local ret
  if debug then print('c8y_alarm.alarmsForSourceAndStatus') end
  url=c8y_alarm.root.resource..'/alarms?source='..source..'&status='..status
  ret=c8y_alarm.get_alarms(url)
  return ret
end

-------------------------
--alarmsForSourceAndStatusAndTime()                                                                                                       
-------------------------
--@source
--@status
--@dateFrom
--@dateTo
-------------------------
function c8y_alarm.alarmsForSourceAndStatusAndTime(source,status,dateFrom,dateTo)                                                                                           
  local ret
  if debug then print('c8y_alarm.alarmsForSourceAndStatusAndTime') end
  url=c8y_alarm.root.resource..'/alarms?source='..source..'&status='..status..'&dateFrom='..dateFrom..'&dateTo='..dateTo
  ret=c8y_alarm.get_alarms(url)
  return ret
end

-------------------------
--alarmsForSourceAndTime()                                                                                                       
-------------------------
--@source
--@dateFrom
--@dateTo
-------------------------
function c8y_alarm.alarmsForSourceAndTime(source,dateFrom,dateTo)                                                                                           
  local ret
  if debug then print('c8y_alarm.alarmsForSourceAndTime') end
  url=c8y_alarm.root.resource..'/alarms?source='..source..'&dateFrom='..dateFrom..'&dateTo='..dateTo
  ret=c8y_alarm.get_alarms(url)
  return ret
end

-------------------------
--alarmsForStatusAndTime()                                                                                                       
-------------------------
--@status
--@dateFrom
--@dateTo
-------------------------
function c8y_alarm.alarmsForStatusAndTime(status,dateFrom,dateTo)                                                                                           
  local ret
  if debug then print('c8y_alarm.alarmsForStatusAndTime') end
  url=c8y_alarm.root.resource..'/alarms?dateFrom='..dateFrom..'&dateTo='..dateTo..'&status='..status
  ret=c8y_alarm.get_alarms(url)
  return ret
end

-------------------------
--alarmsForStatus()                                                                                                       
-------------------------
--@status
-------------------------
function c8y_alarm.alarmsForStatus(status)                                                                                           
  local ret
  if debug then print('c8y_alarm.alarmsForStatus') end
  url=c8y_alarm.root.resource..'/alarms?status='..status
  ret=c8y_alarm.get_alarms(url)
  return ret
end

-------------------------
--alarmsForSource()                                                                                                       
-------------------------
--@source
-------------------------
function c8y_alarm.alarmsForSource(source)                                                                                           
  local ret
  if debug then print('c8y_alarm.alarmsForSource') end
  url=c8y_alarm.root.resource..'/alarms?source='..source
  ret=c8y_alarm.get_alarms(url)
  return ret
end

-------------------------                                                                                                     
--send()                                                                                        
-------------------------                                                                                                     
--c8y_alarm.send
-------------------------                                                                                                     
--@globalid
--@txt
--@status
--@severity
--@time
--@type
-------------------------                                                                                                     
function c8y_alarm.send(globalid,txt,status,severity,time,type)
    local ret, dt
    local obj={}
    if debug then print('c8y_alarm.send') end
    if time ~= nil then
       dt=time
    else
       dt=c8y_date.get()
    end
    obj={source={id=tostring(globalid)},text=txt,time=dt,type=type,status=status,severity=severity}
    ret = c8y_restful.post( c8y_alarm.alarm.type,c8y_alarm.alarm.resource,obj)
    if debug then
        c8y_restful.tabledump(ret)
    end
    return ret
end

-------------------------                                                                                                     
--update()                                                                                        
-------------------------                                                                                                     
--c8y_alarm.update
-------------------------                                                                                                     
--@alarmid
--@status
--@severity
-------------------------                                                                                                     
function c8y_alarm.update(alarmid,status,severity) 
    local ret, dt
    local obj={}
    if debug then print('c8y_alarm.update') end
    if status ~= nil then
      obj['status']=status
    end
    if severity ~= nil then
      obj['severity']=severity
    end
    ret = c8y_restful.put( c8y_alarm.alarm.type,c8y_alarm.alarm.resource..'/'..tostring(alarmid),obj)
    if debug then
        c8y_restful.tabledump(ret)
    end
    return ret
end

-------------------------                                                                                                     
--delete()                                                                                        
-------------------------                                                                                                     
--@url
-------------------------                                                                                                     
function c8y_alarm.delete(url)
    local ret
    if debug then print('c8y_alarm.delete') end
    url=string.gsub(url,'+','%%2B')
    ret = c8y_restful.delete( c8y_alarm.alarm.type,url)
    if debug then
       c8y_restful.tabledump(ret)
    end
    return ret
end

-------------------------                                                                                                     
--c8y_alarm.deletebyid()                                                                                        
-------------------------                                                                                                     
--@id
-------------------------                                                                                                     
function c8y_alarm.deletebyid(id)
    local ret
    if debug then print('c8y_alarm.deletebyid') end
    url=c8y_alarm.alarm.resource..'/'..tostring(id)
    ret = c8y_alarm.delete( url)
    return ret
end



-------------------------                                                                                                     
--test()                                                                                        
-------------------------                                                                                                     
if debug then
function c8y_alarm.test()
  local globalid,self
  local dateFrom,dateTo,fragmentType,type
  local relay ='OPEN'
  --
  --Init
  --
  dateFrom=c8y_date.get()
  --
  --Create device test
  --
  ret=c8y_inventory.create({name="test"})
  c8y_restful.tabledump(ret)
  self=ret.location
  globalid=c8y_inventory.get_id(ret.location)
  print('Location: '..self..'- globalid: '..globalid)
  self=ret.location
  c8y_inventory.update(globalid,{c8y_IsDevice={},com_cumulocity_model_Agent={}})
  c8y_inventory.get_byid(globalid)
  --
  --Send alarm
  --
  ret=c8y_alarm.send(globalid,'Alarm1',c8y_alarm.status.ACTIVE,c8y_alarm.severity.MAJOR,nil,'Alarm1')
  os.execute('sleep 1')
  alarmid1=c8y_inventory.get_id(ret.location)
  ret=c8y_alarm.send(globalid,'Alarm2',c8y_alarm.status.ACTIVE,c8y_alarm.severity.MINOR,nil,'Alarm2')
  os.execute('sleep 1')
  alarmid2=c8y_inventory.get_id(ret.location)
  c8y_alarm.update(alarmid1,nil,c8y_alarm.severity.MINOR)
  c8y_alarm.update(alarmid1,c8y_alarm.status.ACKNOWLEDGED,nil)
  c8y_alarm.update(alarmid2,c8y_alarm.status.ACKNOWLEDGED,c8y_alarm.severity.MAJOR)
  --
  --Get alarm
  --
  c8y_alarm.alarmsForSource(globalid)
  dateTo=c8y_date.get()
  c8y_alarm.alarmsForTime(dateFrom,dateTo)
  c8y_alarm.alarmsForSourceAndTime(globalid,dateFrom,dateTo)
  c8y_alarm.alarmsForSourceAndStatus(globalid,c8y_alarm.status.ACTIVE)
  c8y_alarm.alarmsForSourceAndStatusAndTime(globalid,c8y_alarm.status.ACTIVE,c8y_alarm.status.ACTIVE,dateFrom,dateTo)
  c8y_alarm.alarmsForStatusAndTime(c8y_alarm.status.ACTIVE,dateFrom,dateTo)
  c8y_alarm.alarmsForStatus(c8y_alarm.status.ACTIVE)
  --c8y_inventory.deletebyid(globalid)
  --c8y_inventory.get_managedobjects()
  c8y_inventory.get_byid(globalid)
end
end


return c8y_alarm
