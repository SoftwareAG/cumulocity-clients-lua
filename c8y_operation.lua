-----------------------------------------------------------------------------                                           
-- c8y_operation: for Cumulocity operation management.                                                                  
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
                                                                                                                                   
c8y_operation = {
	root ={type='application/vnd.com.nsn.cumulocity.devicecontrolApi+json',resource='/devicecontrol'},
	operation ={type='application/vnd.com.nsn.cumulocity.operation+json',resource='/devicecontrol/operations'},
	operationcollection ={type='application/vnd.com.nsn.cumulocity.operationApi+json',resource=''},
	status={PENDING='PENDING',SUCCESSFUL='SUCCESSFUL',FAILED='FAILED',EXECUTING='EXECUTING'}
}

-------------------------                                                                                                                                   
--get_api()                                                                                                                                          
-------------------------                                                                                                                                   
function c8y_operation.get_api() 
  local ret, code, head
  ret, code, head = c8y_restful.get( c8y_operation.root.type,c8y_operation.root.resource )
  if debug then
        c8y_restful.tabledump(ret)
  end
end

-------------------------                                                
--get_operations()                                                                                                       
-------------------------                                                                                                                   
--@url
-------------------------                                                                                                                   
function c8y_operation.get_operations(url)                                                                                           
    local ret
    local ret0={}
    
    if debug then print('c8y_operation.get_operations') end
    url=string.gsub(url,'+','%%2B')
                                                                                                                                            
    ret = c8y_restful.get(c8y_operation.root.type,url)
    if debug and ret then
        c8y_restful.tabledump(ret)
    end
    ret0={ret}
    
    while ret and ret.next and ret.operations[1] ~= nil do
      if not ( ret and ret.next ) then break end
       print( '-------> ret.next: '..ret.next )
       ret = c8y_restful.get( c8y_operation.root.type,ret.next )
       if ret.operations[1] == nil then break end
       if debug and ret then
          c8y_restful.tabledump(ret)
      end
      ret0={ret0,ret}
    end
    return ret0
end

-------------------------
--operationsDeviceId()                                                                                                       
-------------------------
--@deviceId
-------------------------
function c8y_operation.operationsDeviceId(deviceId)                                                                                           
  local ret
  if debug then print('c8y_operation.operationsDeviceId') end
  url=c8y_operation.root.resource..'/operations?deviceId='..deviceId
  ret=c8y_operation.get_operations(url)
  return ret
end

-------------------------
--operationsByAgentId()                                                                                                       
-------------------------
--@agentId
-------------------------
function c8y_operation.operationsByAgentId(agentId)                                                                                           
  local ret
  if debug then print('c8y_operation.operationsByAgentId') end
  url=c8y_operation.root.resource..'/operations?agentId='..agentId
  ret=c8y_operation.get_operations(url)
  return ret
end

-------------------------
--operationsByAgentIdAndStatus()                                                                                                       
-------------------------
--@agentId
--@status
-------------------------
function c8y_operation.operationsByAgentIdAndStatus(agentId,status)                                                                                           
  local ret
  if debug then print('c8y_operation.operationsByAgentIdAndStatus') end
  url=c8y_operation.root.resource..'/operations?agentId='..agentId..'&status='..status
  ret=c8y_operation.get_operations(url)
  return ret
end

-------------------------
--operationsByStatus()                                                                                                       
-------------------------
--@status
-------------------------
function c8y_operation.operationsByStatus(status)                                                                                           
  local ret
  if debug then print('c8y_operation.operationsByStatus') end
  url=c8y_operation.root.resource..'/operations?status='..status
  ret=c8y_operation.get_operations(url)
  return ret
end

-------------------------
--operationsByDeviceIdAndStatus()                                                                                                       
-------------------------
--@deviceId
--@status
-------------------------
function c8y_operation.operationsByDeviceIdAndStatus(deviceId,status)                                                                                           
  local ret
  if debug then print('c8y_operation.operationsByDeviceIdAndStatus') end
  url=c8y_operation.root.resource..'/operations?deviceId='..deviceId..'&status='..status
  ret=c8y_operation.get_operations(url)
  return ret
end

-------------------------
--operationsByDeviceId()                                                                                                       
-------------------------
--@deviceId
-------------------------
function c8y_operation.operationsByDeviceId(deviceId)                                                                                           
  local ret
  if debug then print('c8y_operation.operationsByDeviceId') end
  url=c8y_operation.root.resource..'/operations?deviceId='..deviceId
  ret=c8y_operation.get_operations(url)
  return ret
end




-------------------------                                                                                                     
--send()                                                                                        
-------------------------                                                                                                     
--c8y_operation.send
-------------------------                                                                                                     
--@globalid
--@oper
-------------------------                                                                                                     
function c8y_operation.send(globalid,oper)
    local ret
    local obj={}
    obj=oper
    obj['deviceId']=globalid
    ret = c8y_restful.post(c8y_operation.operation.type,c8y_operation.operation.resource,obj)
    if debug then
        c8y_restful.tabledump(ret)
    end
    return ret
end

-------------------------                                                                                                     
--update()                                                                                        
-------------------------                                                                                                     
--c8y_operation.update
-------------------------                                                                                                     
--@operationid
--@status
-------------------------                                                                                                     
function c8y_operation.update(operationid,status)
    local ret, dt
    local obj={}
    if debug then print('c8y_operation.update') end
    obj={status=status}
    ret = c8y_restful.put( c8y_operation.operation.type,c8y_operation.operation.resource..'/'..tostring(operationid),obj)
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
function c8y_operation.delete(url)
    local ret
    if debug then print('c8y_operation.delete') end
    url=string.gsub(url,'+','%%2B')
    ret = c8y_restful.delete( c8y_operation.operation.type,url)
    if debug then
       c8y_restful.tabledump(ret)
    end
    return ret
end

-------------------------                                                                                                     
--c8y_operation.deletebyid()                                                                                        
-------------------------                                                                                                     
--@id
-------------------------                                                                                                     
function c8y_operation.deletebyid(id)
    local ret
    if debug then print('c8y_operation.deletebyid') end
    url=c8y_operation.operation.resource..'/'..tostring(id)
    ret = c8y_operation.delete( url)
    return ret
end



-------------------------                                                                                                     
--test()                                                                                        
-------------------------                                                                                                     
if debug then
function c8y_operation.test()
  local globalid
  local agentid=1
  --
  --Create device test
  --
  ret=c8y_inventory.create({name="test"})
  c8y_restful.tabledump(ret)
  globalid=c8y_inventory.get_id(ret.location)
  c8y_inventory.update(globalid,{c8y_IsDevice={},com_cumulocity_model_Agent={}})
  c8y_inventory.update(globalid,{c8y_SupportedOperations={c8y_Restart={},c8y_Configuration={},c8y_Software={},c8y_Firmware={}}})
  c8y_inventory.get_byid(globalid)
  --
  --Send operation
  --
  print('--------> c8y_operation.test: globalid= '..globalid)
  ret=c8y_operation.send(globalid,{c8y_Restart={}})
  operationid1=c8y_inventory.get_id(ret.location)
  os.execute('sleep 1')
  ret=c8y_operation.send(globalid,{c8y_Configuration={value=1}})
  operationid2=c8y_inventory.get_id(ret.location)
  os.execute('sleep 1')
  c8y_operation.update(operationid1,c8y_operation.status.EXECUTING)
  ret=c8y_operation.operationsByDeviceIdAndStatus(globalid,c8y_operation.status.PENDING)
  c8y_restful.tabledump(ret)
  if ret and ret[1].operations and ret[1].operations[1].c8y_Configuration then
    operationid=ret[1].operations[1].id
    value=ret[1].operations[1].c8y_Configuration.value
    print('c8y_operation.test: value= '..value )
    c8y_operation.update(operationid,c8y_operation.status.SUCCESSFUL)
  end
  --
  --Get operation
  --
  c8y_operation.operationsByStatus(c8y_operation.status.SUCCESSFUL)
  c8y_operation.operationsByDeviceIdAndStatus(globalid,c8y_operation.status.EXECUTING)
  c8y_operation.operationsByDeviceId(globalid)
  --c8y_operation.operationsByAgentId(agentid)
  --c8y_operation.operationsByAgentIdAndStatus(agentid,c8y_operation.status.PENDING)
  --c8y_inventory.deletebyid(globalid)
  --c8y_inventory.get_managedobjects()
  c8y_inventory.get_byid(globalid)
end
end


return c8y_operation
