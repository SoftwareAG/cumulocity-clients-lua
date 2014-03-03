-----------------------------------------------------------------------------
-- c8y_restful: for Cumulocity RESTful management.
-- Author: www.DoNovae.com - Herve BAILLY
-- Date: Frebruary 2014
-- Version: 1.0.0
-- This module is released under the GPL License
-----------------------------------------------------------------------------
-- Inspired by https://github.com/fertesta/restinlua
----------------------------------
require 'logger'
local debug0=true
local debug=true
local json=require('luci.json')
local http = require('socket.http')
local mime = require("mime")
require 'socket'


c8y_restful = {
	errno ={},
--demo
--	host ='http://developer.cumulocity.com',
--	user ='',
--	password ='',
--	tenant ='demo',
--	authorisation ='Basic ...',
--	key ='uL27no8nhvLlYmW1JIK1CA==',
--donovae
	host ='',
	user ='',
	password ='',
	tenant ='',
	root={type='application/vnd.com.nsn.cumulocity.platformApi+jsona',resource='/platform'},
	error={type='application/vnd.com.nsn.cumulocity.error+json',resource='/error'},
	statistics={type='application/vnd.com.nsn.cumulocity.pagingStatistics+json',resource='/pagingstatistics'},
	type_version='ver=0.9;charset=UTF-8',
}

c8y_restful.errno[400]='Bad Request The request could not be understood by the server due to malformed syntax. The client SHOULD NOT repeat the request without modifications.'
c8y_restful.errno[401]='Unauthorized - Authentication has failed, or credential were required but not provided.'
c8y_restful.errno[403]='Forbidden - You are not authorized to access the API.'
c8y_restful.errno[404]='Not Found - Resource not found at given location.'
c8y_restful.errno[405]='Method not allowed - The employed HTTP method cannot be used on this resource, using POST on a read-only resource'
c8y_restful.errno[409]='Update Conflict - Conflict on resource update, entity was changed in the meantime. Or duplicate - The entity already exists in the data source.'
c8y_restful.errno[415]='Unsupported Media Type.'
c8y_restful.errno[422]='Invalid Data - General error with entity data format. Or non unique Result - Resource constraints error. Non-unique result from the query. Or unprocessable entity - Resource cannot be processed.'
c8y_restful.errno[500]='Internal Server Error - An internal error in the software system has occurred and the request could not be processed.'
c8y_restful.errno[503]='Service Unavailable - The service is currently not available. This may be caused by an overloaded instance or it is down for maintenance. Please try it again in a few minutes.'


-------------------------
-- c8y_restful.get
-------------------------
--@type: Content-Type 
--@resource: URI  
-------------------------
function c8y_restful.get(type,resource)
	local chunks = {}
	local chkall =''
	local jsondecode={}
	if ( string.sub(resource,1,1) == '/' ) then
	  url = c8y_restful.host..resource
	else
	  url = resource
	end
	if debug then 
  		print('--------> url= '..url)
  		print('--------> type= '..type)
  	end
	ret, code, head = http.request(
	{ ['url'] = url,
		method = 'GET',
		headers = {  
--			['Authorization'] = c8y_restful.authorisation, 
--			['X-Cumulocity-Application-Key'] = c8y_restful.key, 
			['Accept'] = '*/*', 
			['Content-Type'] = type..';'..c8y_restful.type_version, 
		}, 
		user=c8y_restful.tenant..'/'..c8y_restful.user,
		password=c8y_restful.password,
		sink = ltn12.sink.table(chunks)
	}
	)
	for i=1,#chunks do chkall=chkall..chunks[i] end
	if debug then 
		if chunks and chunks[1] then
			print('DEBUG: c8y_restful.get(): chunks[1]='..chkall)
		end
		if ret then print('DEBUG: c8y_restful.get():  ret='..ret) end
		print('DEBUG: c8y_restful.get(): code='..code)
		print('DEBUG: c8y_restful.get(): head='..json.encode(head))
	end

	if code >= 400 then
		err=c8y_restful.errno[code]
		if err ~= nil then
			logger.write( 'c8y_restful.get','Error',url..' - error '..tostring(code)..': '..err)
	 	end
	 	return nil
	end
	if chunks~=nil then
		ret, code, head=json.decode(chkall)
		return ret
	else
	 	return nil
	end
end

-------------------------
-- c8y_restful.post
-------------------------
--@type: Content-Type 
--@resource: URI  
--@object: {name='',type=''}  
-------------------------
function c8y_restful.post(type,resource, object)
	local url ='' 
	local chkall =''
	local chunks = {}
	local body = json.encode(object or {})
	if debug then 
		print("DEBUG: c8y_restful.post(): body="..body) 
	end
	if ( string.sub(resource,1,1) == '/' ) then
	  url = c8y_restful.host..resource
	else
	  url = resource
	end
	if debug then 
  		print('--------> url= '..url)
  		print('--------> type= '..type)
	end
	local ret, code, head = http.request(
		{ ['url'] = url,
			method = 'POST',
			headers = {  
--				['Authorization'] = c8y_restful.authorisation, 
--				['X-Cumulocity-Application-Key'] = c8y_restful.key, 
				['Accept'] = '*/*', 
				['Content-Type'] = type..';'..c8y_restful.type_version, 
				['Content-Length'] = body:len() 
			}, 
			source = ltn12.source.string(body), 
			user=c8y_restful.tenant..'/'..c8y_restful.user,
			password=c8y_restful.password,
			sink = ltn12.sink.table(chunks)
		}
	)
	if code >= 400 then
		err=c8y_restful.errno[code]
		if err ~= nil then
			logger.write( 'c8y_restful.post','Error',url..' - error '..tostring(code)..': '..err)
	 	end
	 	return nil
	end
	for i=1,#chunks do chkall=chkall..chunks[i] end
	if debug then 
		if chunks and chunks[1] then
			print('DEBUG: c8y_restful.post(): chunks[1]='..chunks[1])
		end
		if ret then print('DEBUG: c8y_restful.post():  ret='..ret) end
		print('DEBUG: c8y_restful.post(): code='..code)
		print('DEBUG: c8y_restful.post(): head='..json.encode(head))
	end
    return head	
end

-------------------------
-- c8y_restful.put
-------------------------
--@type: Content-Type 
--@resource: URI  
--@object: {name='',type=''}  
-------------------------
function c8y_restful.put(type,resource, object)
	local url ='' 
	local chkall =''
	local chunks = {}
	local body = json.encode(object or {})
	if debug then 
		print("DEBUG: c8y_restful.put(): body="..body) 
	end
	if ( string.sub(resource,1,1) == '/' ) then
	  url = c8y_restful.host..resource
	else
	  url = resource
	end
	if debug then 
  		print('----------> url= '..url)
  		print('----------> type= '..type)
	end
	local ret, code, head = http.request(
		{ ['url'] = url,
			method = 'PUT',
			headers = {  
--				['Authorization'] = c8y_restful.authorisation, 
--				['X-Cumulocity-Application-Key'] = c8y_restful.key, 
				['Accept'] = '*/*', 
				['Content-Type'] = type..';'..c8y_restful.type_version, 
				['Content-Length'] = body:len() 
			}, 
			source = ltn12.source.string(body), 
			user=c8y_restful.tenant..'/'..c8y_restful.user,
			password=c8y_restful.password,
			sink = ltn12.sink.table(chunks)
		}
	)
	if code >= 400 then
		err=c8y_restful.errno[code]
		if err ~= nil then
			logger.write( 'c8y_restful.post','Error',url..' - error '..tostring(code)..': '..err)
	 	end
	 	return nil
	end
	for i=1,#chunks do chkall=chkall..chunks[i] end
	if debug then 
		if chunks and chunks[1] then
			print('DEBUG: c8y_restful.put(): chunks[1]='..chunks[1])
		end
		if ret then print('DEBUG: c8y_restful.put():  ret='..ret) end
		print('DEBUG: c8y_restful.put(): code='..code)
		print('DEBUG: c8y_restful.put(): head='..json.encode(head))
	end
	
	if chunks~=nil then
		ret, code, head=json.decode(chkall)
		return ret
	else
	 	return nil
	end
end
-------------------------
-- c8y_restful.delete
-------------------------
--@type: Content-Type 
--@url: 
-------------------------
function c8y_restful.delete(type,resource)
	local chunks = {}
	local url=''
	if ( string.sub(resource,1,1) == '/' ) then
	  url = c8y_restful.host..resource
	else
	  url = resource
	end
	if debug then 
  		print('--------> url= '..url)
  		print('--------> type= '..type)
	end
	local ret, code, head = http.request(
		{ ['url'] = url,
			method = 'DELETE',
			headers = {  
--				['Authorization'] = c8y_restful.authorisation, 
--				['X-Cumulocity-Application-Key'] = c8y_restful.key, 
				['Accept'] = '*/*', 
				['Content-Type'] = type..';'..c8y_restful.type_version, 
			}, 
			user=c8y_restful.tenant..'/'..c8y_restful.user,
			password=c8y_restful.password,
			sink = ltn12.sink.table(chunks)
		}
	)
	if debug then 
		print('DEBUG: c8y_restful.delete(): code='..code)
		print('DEBUG: c8y_restful.delete(): head='..json.encode(head))
		print('DEBUG: c8y_restful.delete():  ret='..json.encode(ret))
	end
	if code >= 400 then
		err=c8y_restful.errno[code]
		if err ~= nil then
			logger.write( 'c8y_restful.delete','Error',url..' - error '..tostring(code)..': '..err)
	 	end
	 	return nil
	end
		return {}
end

	
-------------------------                                                                                                                                   
-- c8y_restful.get_api
-------------------------                                                                                                                                   
-- Return platform API
-------------------------                                                                                                                                   
function c8y_restful.get_api()
	local ret
	ret = c8y_restful.get(c8y_restful.root.type,c8y_restful.root.resource) 
	if debug0 then 
	   c8y_restful.tabledump(ret)
	end
	return ret
end

-------------------------                                                                                                                                   
-- c8y_restful.get_statistics
-------------------------                                                                                                                                   
-- Return platform statistics
-------------------------                                                                                                                                   
function c8y_restful.get_statistics()
	local ret
	ret = c8y_restful.get(c8y_restful.statistics.type,c8y_restful.statistics.resource) 
	if debug0 then 
	   c8y_restful.tabledump(ret)
	end
	return ret
end

-------------------------                                                                                                                                   
-- c8y_restful.get_error
-------------------------                                                                                                                                   
-- Return error request
-------------------------                                                                                                                                   
function c8y_restful.get_error()
	local ret
	ret = c8y_restful.get(c8y_restful.error.type,c8y_restful.error.resource) 
	if debug0 then 
	   c8y_restful.tabledump(ret)
	end
	return ret
end

-------------------------
-- tabledump(t,indent) 
-------------------------
-- @t: table 
-- @indent: indentation  
-------------------------
function  c8y_restful.tabledump(t,indent)
	if type(t) ~= 'table' then return end
	local indent = indent or 0
	for k,v in pairs(t) do
		if type(v)=="table" then
			print(string.rep(" ",indent)..k.."=>")
			c8y_restful.tabledump(v, indent+4)
		else
			print(string.rep(" ",indent) .. k  .. "=>" .. tostring(v))
		end
	end
end

return c8y_restful
