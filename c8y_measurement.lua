-----------------------------------------------------------------------------                                           
-- c8y_measurement: for Cumulocity measurement management.                                                                  
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
                                                                                                                                   
c8y_measurement = {
	root ={type='application/vnd.com.nsn.cumulocity.measurementApi+json',resource='/measurement'},
	measurement ={type='application/vnd.com.nsn.cumulocity.measurement+json',resource='/measurement/measurements'},
	measurementcollection ={type='application/vnd.com.nsn.cumulocity.measurementApi+json',resource=''},
}

-------------------------                                                                                                                                   
--get_api()                                                                                                                                          
-------------------------                                                                                                                                   
function c8y_measurement.get_api() 
  local ret, code, head
  ret, code, head = c8y_restful.get( c8y_measurement.root.type,c8y_measurement.root.resource )
  if debug then
        c8y_restful.tabledump(ret)
  end
end

-------------------------                                                
--get_measurements()                                                                                                       
-------------------------                                                                                                                   
--@url
-------------------------                                                                                                                   
function c8y_measurement.get_measurements(url)                                                                                           
    local ret
    local ret0={}
    
    if debug then print('c8y_measurement.get_measurements') end
    url=string.gsub(url,'+','%%2B')
                                                                                                                                            
    ret = c8y_restful.get(c8y_measurement.root.type,url)
    if debug and ret then
        c8y_restful.tabledump(ret)
    end
    ret0={ret}
    
    while ret and ret.next and ret.measurements[1] ~= nil do
      if not ( ret and ret.next ) then break end
       --print( '------> ret.next: '..ret.next )
       ret = c8y_restful.get( c8y_measurement.root.type,ret.next )
       if ret.measurements[1] == nil then break end
       if debug and ret then
          c8y_restful.tabledump(ret)
      end
      ret0={ret0,ret}
    end
    return ret0
end

-------------------------
--measurementsForDate()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
-------------------------
function c8y_measurement.measurementsForDate(dateFrom,dateTo)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForDate') end
  url=c8y_measurement.root.resource..'/measurements?dateFrom='..dateFrom..'&dateTo='..dateTo
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForSourceAndType()                                                                                                       
-------------------------
--@source
--@type
-------------------------
function c8y_measurement.measurementsForSourceAndType(source,type)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForSourceAndType') end
  url=c8y_measurement.root.resource..'/measurements?source='..source..'&type='..type
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForDateAndType()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
--@type
-------------------------
function c8y_measurement.measurementsForDateAndType(dateFrom,dateTo,type)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForDateAndType') end
  url=c8y_measurement.root.resource..'/measurements?dateFrom='..dateFrom..'&dateTo='..dateTo..'&type='..type
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForFragmentTypeAndType()                                                                                                       
-------------------------
--@fragmentType
--@type
-------------------------
function c8y_measurement.measurementsForFragmentTypeAndType(fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForFragmentTypeAndType') end
  url=c8y_measurement.root.resource..'/measurements?fragmentType='..fragmentType..'&type='..type
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForSourceAndDateAndFragmentTypeAndType()                                                                                                       
-------------------------
--@source
--@dateFrom
--@dateTo
--@fragmentType
--@type
-------------------------
function c8y_measurement.measurementsForSourceAndDateAndFragmentTypeAndType(source,dateFrom,dateTo,fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForSourceAndDateAndFragmentTypeAndType') end
  url=c8y_measurement.root.resource..'measurements?source='..source..'&dateFrom='..dateFrom..'&dateTo='..dateTo..'&fragmentType='..fragmentType..'&type='..type
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForType()                                                                                                       
-------------------------
--@type
-------------------------
function c8y_measurement.measurementsForType(type)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForType') end
  url=c8y_measurement.root.resource..'/measurements?type='..type
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForSource()                                                                                                       
-------------------------
--@source
-------------------------
function c8y_measurement.measurementsForSource(source)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForSource') end
  url=c8y_measurement.root.resource..'/measurements?source='..source
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForDateAndFragmentTypeAndType()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
--@fragmentType
--@type
-------------------------
function c8y_measurement.measurementsForDateAndFragmentTypeAndType(dateFrom,dateTo,fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForDateAndFragmentTypeAndType') end
  url=c8y_measurement.root.resource..'/measurements?dateFrom='..dateFrom..'&dateTo='..dateTo..'&fragmentType='..fragmentType..'&type='..type
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForSourceAndFragmentTypeAndType()                                                                                                       
-------------------------
--@source
--@fragmentType
--@type
-------------------------
function c8y_measurement.measurementsForSourceAndFragmentTypeAndType(source,fragmentType,type)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForSourceAndFragmentTypeAndType') end
  url=c8y_measurement.root.resource..'measurements?source='..source..'&fragmentType='..fragmentType..'&type='..type
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForDateAndFragmentType()                                                                                                       
-------------------------
--@dateFrom
--@dateTo
--@fragmentType
-------------------------
function c8y_measurement.measurementsForDateAndFragmentType(dateFrom,dateTo,fragmentType)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForDateAndFragmentType') end
  url=c8y_measurement.root.resource..'/measurements?dateFrom='..dateFrom..'&dateTo='..dateTo..'&fragmentType='..fragmentType
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------
--measurementsForSourceAndFragmentType()                                                                                                       
-------------------------
--@source
--@fragmentType
-------------------------
function c8y_measurement.measurementsForSourceAndFragmentType(source,fragmentType)                                                                                           
  local ret
  if debug then print('c8y_measurement.measurementsForSourceAndFragmentType') end
  url=c8y_measurement.root.resource..'measurements?source='..source..'&fragmentType='..fragmentType
  ret=c8y_measurement.get_measurements(url)
  return ret
end

-------------------------                                                                                                     
--send()                                                                                        
-------------------------                                                                                                     
--c8y_measurement.send(10700,nil,'temp','c8y_TemperatureMeasurement',{T={value=23,unit='C'}}})
-------------------------                                                                                                     
--@globalid
--@time
--@type
--@measure
-------------------------                                                                                                     
function c8y_measurement.send(globalid,time,type,fragment,value)
    local ret, dt
    local obj={}
    if debug then print('c8y_measurement.send') end
    if time ~= nil then
       dt=time
    else
       dt=c8y_date.get()
    end
    obj={source={id=tostring(globalid)},time=dt,type=type}
    obj[fragment]=value
    ret = c8y_restful.post( c8y_measurement.measurement.type,c8y_measurement.measurement.resource,obj)
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
function c8y_measurement.delete(url)
    local ret
    if debug then print('c8y_measurement.delete') end
    url=string.gsub(url,'+','%%2B')
    ret = c8y_restful.delete( c8y_measurement.measurement.type,url)
    if debug then
       c8y_restful.tabledump(ret)
    end
    return ret
end

-------------------------                                                                                                     
--c8y_measurement.deletebyid()                                                                                        
-------------------------                                                                                                     
--@id
-------------------------                                                                                                     
function c8y_measurement.deletebyid(id)
    local ret
    if debug then print('c8y_measurement.deletebyid') end
    url=c8y_measurement.measurement.resource..'/'..tostring(id)
    ret = c8y_measurement.delete( url)
    return ret
end



-------------------------                                                                                                     
--test()                                                                                        
-------------------------                                                                                                     
if debug then
function c8y_measurement.test()
  local globalid,self
  local dateFrom,dateTo,fragmentType,type
  --
  --Init
  --
  dateFrom=c8y_date.get()
  fragmentType='c8y_TemperatureMeasurement'
  type='temp'
  --
  --Create device test
  --
  ret=c8y_inventory.create({name="test"})
  c8y_restful.tabledump(ret)
  self=ret.location
  globalid=c8y_inventory.get_id(ret.location)
  print('Location: '..self..'- globalid: '..globalid)
  self=ret.location
  c8y_inventory.update(globalid,{c8y_SupportedMeasurements={fragmentType}})
  c8y_inventory.update(globalid,{c8y_IsDevice={},com_cumulocity_model_Agent={}})
  c8y_inventory.get_byid(globalid)
  --
  --Send measurement
  --
  for i=1,2 do
    c8y_measurement.send(globalid,nil,type,fragmentType,{T={value=10*i,unit='C'}})
    os.execute('sleep 1')
  end
  --
  --Get measurement
  --
  c8y_measurement.measurementsForSource(globalid)
  c8y_measurement.measurementsForSourceAndFragmentType(globalid,fragmentType)
  dateTo=c8y_date.get()
  c8y_measurement.measurementsForDate(dateFrom,dateTo)
  c8y_measurement.measurementsForSourceAndType(globalid,type)
  --c8y_measurement.measurementsForFragmentType(fragmentType)
  c8y_measurement.measurementsForDateAndType(dateFrom,dateTo,type)
  --c8y_measurement.measurementsForSourceAndDateAndType(globalid,dateFrom,dateTo,type)
  --c8y_measurement.measurementsForFragmentTypeAndType(fragmentType,type)
  --c8y_measurement.measurementsForSourceAndDate(globalid,dateFrom,dateTo)
  --c8y_measurement.measurementsForSourceAndDateAndFragmentType(globalid,dateFrom,dateTo,fragmentType)
  c8y_measurement.measurementsForSourceAndDateAndFragmentTypeAndType(globalid,dateFrom,dateTo,fragmentType,type)
  --c8y_measurement.measurementsForType(type)
  c8y_measurement.measurementsForDateAndFragmentTypeAndType(dateFrom,dateTo,fragmentType,type)
  c8y_measurement.measurementsForSourceAndFragmentTypeAndType(globalid,fragmentType,type)
  c8y_measurement.measurementsForDateAndFragmentType(dateFrom,dateTo,fragmentType)
  --c8y_inventory.deletebyid(globalid)
  --c8y_inventory.get_managedobjects()
  c8y_inventory.get_byid(globalid)
end
end


return c8y_measurement
