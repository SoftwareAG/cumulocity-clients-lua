-----------------------------------------------------------------------------                                           
-- c8y_event: for Cumulocity event management.                                                                  
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
                                                                                                                                   
c8y_event = {
	root ={type='application/vnd.com.nsn.cumulocity.eventApi+json',resource='/event'},
	event ={type='application/vnd.com.nsn.cumulocity.event+json',resource='/event/events'},
	eventcollection ={type='application/vnd.com.nsn.cumulocity.eventApi+json',resource=''},
}

-------------------------                                                                                                                                   
--get_api()                                                                                                                                          
-------------------------                                                                                                                                   
function c8y_event.get_api() 
  local ret, code, head
  ret, code, head = c8y_restful.get( c8y_event.root.type,c8y_event.root.resource )
  if debug then
        c8y_restful.tabledump(ret)
  end
end

-------------------------                                                
--get_events()                                                                                                       
-------------------------                                                                                                                   
--@url
-------------------------                                                                                                                   
function c8y_event.get_events(url)                                                                                           
    local ret
    local ret0={}
    
    if debug then print('c8y_event.get_events') end
    url=string.gsub(url,'+','%%2B')
                                                                                                                                            
    ret = c8y_restful.get(c8y_event.root.type,url)
    if debug and ret then
        c8y_restful.tabledump(ret)
    end
    ret0={ret}
    
    while ret and ret.next and ret.events[1] ~= nil do
      if not ( ret and ret.next ) then break end
       --print( '-------> ret.next: '..ret.next )
       ret = c8y_restful.get( c8y_event.root.type,ret.next )
       if ret.events[1] == nil then break end
       if debug and ret then
          c8y_restful.tabledump(ret)
      end
      ret0={ret0,ret}
    end
    return ret0
end

-------------------------
--eventsForTime()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
-------------------------
function c8y_event.eventsForTime(dateFrom,dateTo)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForDate') end
  url=c8y_event.root.resource..'/events?dateFrom='..dateFrom..'&dateTo='..dateTo
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForSourceAndType()                                                                                                       
-------------------------
--@source
--@type
-------------------------
function c8y_event.eventsForSourceAndType(source,type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForSourceAndType') end
  url=c8y_event.root.resource..'/events?source='..source..'&type='..type
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForTimeAndType()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
--@type
-------------------------
function c8y_event.eventsForTimeAndType(dateFrom,dateTo,type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForTimeAndType') end
  url=c8y_event.root.resource..'/events?dateFrom='..dateFrom..'&dateTo='..dateTo..'&type='..type
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForFragmentTypeAndType()                                                                                                       
-------------------------
--@fragmentType
--@type
-------------------------
function c8y_event.eventsForFragmentTypeAndType(fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForFragmentTypeAndType') end
  url=c8y_event.root.resource..'/events?fragmentType='..fragmentType..'&type='..type
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForFragmentType()                                                                                                       
-------------------------
--@fragmentType
-------------------------
function c8y_event.eventsForFragmentType(fragmentType)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForFragmentType') end
  url=c8y_event.root.resource..'/events?fragmentType='..fragmentType
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForFragmentTypeAndType()                                                                                                       
-------------------------
--@fragmentType
--@type
-------------------------
function c8y_event.eventsForFragmentTypeAndType(fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForFragmentTypeAndType') end
  url=c8y_event.root.resource..'/events?fragmentType='..fragmentType..'&type='..type
  ret=c8y_event.get_events(url)
  return ret
end
-------------------------
--eventsForSourceAndDateAndFragmentTypeAndType()                                                                                                       
-------------------------
--@source
--@dateFrom
--@dateTo
--@fragmentType
--@type
-------------------------
function c8y_event.eventsForSourceAndDateAndFragmentTypeAndType(source,dateFrom,dateTo,fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForSourceAndDateAndFragmentTypeAndType') end
  url=c8y_event.root.resource..'events?source='..source..'&dateFrom='..dateFrom..'&dateTo='..dateTo..'&fragmentType='..fragmentType..'&type='..type
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForType()                                                                                                       
-------------------------
--@type
-------------------------
function c8y_event.eventsForType(type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForType') end
  url=c8y_event.root.resource..'/events?type='..type
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForSource()                                                                                                       
-------------------------
--@source
-------------------------
function c8y_event.eventsForSource(source)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForSource') end
  url=c8y_event.root.resource..'/events?source='..source
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForDateAndFragmentTypeAndType()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
--@fragmentType
--@type
-------------------------
function c8y_event.eventsForDateAndFragmentTypeAndType(dateFrom,dateTo,fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForDateAndFragmentTypeAndType') end
  url=c8y_event.root.resource..'/events?dateFrom='..dateFrom..'&dateTo='..dateTo..'&fragmentType='..fragmentType..'&type='..type
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForSourceAndFragmentTypeAndType()                                                                                                       
-------------------------
--@source
--@fragmentType
--@type
-------------------------
function c8y_event.eventsForSourceAndFragmentTypeAndType(source,fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForSourceAndFragmentTypeAndType') end
  url=c8y_event.root.resource..'events?source='..source..'&fragmentType='..fragmentType..'&type='..type
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForDateAndFragmentType()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
--@fragmentType
-------------------------
function c8y_event.eventsForDateAndFragmentType(dateFrom,dateTo,fragmentType)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForDateAndFragmentType') end
  url=c8y_event.root.resource..'/events?dateFrom='..dateFrom..'&dateTo='..dateTo..'&fragmentType='..fragmentType
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------
--eventsForSourceAndFragmentType()                                                                                                       
-------------------------
--@source
--@fragmentType
-------------------------
function c8y_event.eventsForSourceAndFragmentType(source,fragmentType)                                                                                           
  local ret
  if debug then print('c8y_event.eventsForSourceAndFragmentType') end
  url=c8y_event.root.resource..'events?source='..source..'&fragmentType='..fragmentType
  ret=c8y_event.get_events(url)
  return ret
end

-------------------------                                                                                                     
--send()                                                                                        
-------------------------                                                                                                     
--c8y_event.send(10700,nil,'temp','c8y_Temperatureevent',{T={value=23,unit='C'}}})
-------------------------                                                                                                     
--@globalid
--@time
--@type
--@measure
-------------------------                                                                                                     
function c8y_event.send(globalid,txt,time,type,fragment,value)
    local ret, dt
    local obj={}
    if debug then print('c8y_event.send') end
    if time ~= nil then
       dt=time
    else
       dt=c8y_date.get()
    end
    obj={source={id=tostring(globalid)},text=txt,time=dt,type=type}
    obj[fragment]=value
    ret = c8y_restful.post( c8y_event.event.type,c8y_event.event.resource,obj)
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
function c8y_event.delete(url)
    local ret
    if debug then print('c8y_event.delete') end
    url=string.gsub(url,'+','%%2B')
    ret = c8y_restful.delete( c8y_event.event.type,url)
    if debug then
       c8y_restful.tabledump(ret)
    end
    return ret
end

-------------------------                                                                                                     
--c8y_event.deletebyid()                                                                                        
-------------------------                                                                                                     
--@id
-------------------------                                                                                                     
function c8y_event.deletebyid(id)
    local ret
    if debug then print('c8y_event.deletebyid') end
    url=c8y_event.event.resource..'/'..tostring(id)
    ret = c8y_event.delete( url)
    return ret
end



-------------------------                                                                                                     
--test()                                                                                        
-------------------------                                                                                                     
if debug then
function c8y_event.test()
  local globalid,self
  local dateFrom,dateTo,fragmentType,type
  local relay ='OPEN'
  --
  --Init
  --
  dateFrom=c8y_date.get()
  fragmentType='c8y_Relay'
  type='Relay'
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
  c8y_inventory.update(globalid,{c8y_SupportedEvents={fragmentType={relayState=relay}}})
  c8y_inventory.get_byid(globalid)
  --
  --Send event
  --
  for i=1,5 do
    if relay == 'OPEN' then 
      relay ='CLOSED'
    else
      relay ='OPEN'
    end 
    c8y_event.send(globalid,relay,nil,type,fragmentType,{relayState=relay})
    os.execute('sleep 1')
  end
  --
  --Get event
  --
  c8y_event.eventsForSource(globalid)
  c8y_event.eventsForSourceAndFragmentType(globalid,fragmentType)                                                                                           
  dateTo=c8y_date.get()
  c8y_event.eventsForDateAndFragmentType(dateFrom,dateTo,fragmentType)                                                                                           
  --c8y_event.eventsForSourceAndTimeAndType(dateFrom,dateTo,fragmentType)                                                                                           
  --c8y_event.eventsForSourceAndDateAndFragmentTypeAndType(globalid,dateFrom,dateTo,fragmentType,type)
  c8y_event.eventsForDateAndFragmentTypeAndType(dateFrom,dateTo,fragmentType,type)
  c8y_event.eventsForFragmentType(fragmentType)                                                                                           
  --c8y_event.eventsForSourceAndDateAndFragmentType(globalid,dateFrom,dateTo,fragmentType)                                                                                           
  c8y_event.eventsForTimeAndType(dateFrom,dateTo,type)
  c8y_event.eventsForSourceAndFragmentType(globalid,fragmentType)
  c8y_event.eventsForType(type)
  c8y_event.eventsForTime(dateFrom,dateTo)
  --c8y_event.eventsForSourceAndTime(globalid,dateFrom,dateTo)
  c8y_event.eventsForSourceAndFragmentTypeAndType(globalid,fragmentType,type)
  c8y_event.eventsForSourceAndType(globalid,type)
  c8y_event.eventsForFragmentTypeAndType(fragmentType,type)
  --c8y_inventory.deletebyid(globalid)
  --c8y_inventory.get_managedobjects()
  c8y_inventory.get_byid(globalid)
end
end


return c8y_event
