-----------------------------------------------------------------------------
-- c8y_identity: for Cumulocity identity management.
-- Author: www.DoNovae.com - Herve BAILLY
-- Date: Frebruary 2014
-- Version: 1.0.0
-- This module is released under the GPL License
-----------------------------------------------------------------------------

local debug=true                                                                                                                   
local json=require('luci.json')                                                                                                    
local c8y =require('c8y_restful')                                                                                                

local debug=true                                                                                                                                   
                                                                                                                                   
c8y_identity = {
	root ={type='application/vnd.com.nsn.cumulocity.identityApi+json',resource='/identity'},
	externalidcollection={type='application/vnd.com.nsn.cumulocity.externalIdCollection+json',resource=''},
	externalid={type='application/vnd.com.nsn.cumulocity.externalId+json',resource=''},
}

-------------------------                                                                                                                                   
-- c8y_identity.get_api()                                                                                                                                          
-------------------------                                                                                                                                   
function c8y_identity.get_api() 
  local ret, code, head
  ret, code, head = c8y.get( c8y_identity.root.type,c8y_identity.root.resource )
  if debug then
        c8y.tabledump(ret)
  end
end

-------------------------
-- c8y_identity.get_externalid
-------------------------
--@globalId
-------------------------
function c8y_identity.get_externalid(globalId) 
  local ret
    ret = c8y.get( c8y_identity.externalidcollection.type,c8y_identity.root.resource..'/globalIds/'..globalId..'/externalIds' )
    if debug then
        c8y.tabledump(ret)
    end
end


-------------------------                                                                                                                                   
-- c8y_identity.set_externalid
-------------------------                                                                                                                                   
--@globalId
--@type
--@externalid
-------------------------                                                                                                                                   
function c8y_identity.set_externalid(globalId,type,externalid) 
    local ret
    local  obj={type=type,externalId=externalid}
    ret = c8y.post( c8y_identity.externalid.type,c8y_identity.root.resource..'/globalIds/'..globalId..'/externalIds',obj )
    if debug then
        c8y.tabledump(ret)
    end
end


return c8y_identity
