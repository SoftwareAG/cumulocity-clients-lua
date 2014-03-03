-----------------------------------------------------------------------------
-- c8y_inventory: for Cumulocity inventory management. 
-- Author: www.DoNovae.com - Herve BAILLY 
-- Date: Frebruary 2014
-- Version: 1.0û0
-- This module is released under the GPL License
-----------------------------------------------------------------------------

local debug=true                                                                                                                   
local json=require('luci.json')                                                                                                    
local c8y =require('c8y_restful')                                                                                                
util=require 'luci.util'

local debug=true                                                                                                                                   
                                                                                                                                   
c8y_inventory = {
	root ={type='application/vnd.com.nsn.cumulocity.inventoryApi+json',resource='/inventory'},
	managedobjects ={type='application/vnd.com.nsn.cumulocity.managedObject+json',resource='/inventory/managedObjects'},
	managedobjectcollection ={type='application/vnd.com.nsn.cumulocity.managedObjectCollection+json',resource=''},
	managedobjectreferencecollection ={type='application/vnd.com.nsn.cumulocity.managedObjectReferenceCollection+json',resource=''},
	managedobjectreference ={type='application/vnd.com.nsn.cumulocity.managedObjectReference+json',resource=''}
}

-------------------------
-- c8y_inventory.get_api()
-------------------------
--@url
-------------------------
function c8y_inventory.get_id(url) 
  local tab
  tab=util.split(url,'/')
  return tab[#tab] 
end

-------------------------
-- c8y_inventory.get_api()
-------------------------                                                                                                                                   
function c8y_inventory.get_api() 
  local ret, code, head
  ret, code, head = c8y.get( c8y_inventory.root.type,c8y_inventory.root.resource )
  if debug then
        c8y.tabledump(ret)
  end
  return ret
end

-------------------------                                                                                                                                   
-- c8y_inventory.get_byid                                                                                                                                          
-------------------------                                                                                                                                   
-- c8y_inventory.get_byid('114200')
-------------------------                                                                                                                                   
function c8y_inventory.get_byid(globalid) 
    local ret
    if debug then print('c8y_inventory.get_byid') end
    ret = c8y.get( c8y_inventory.root.type,c8y_inventory.root.resource..'/managedObjects/'..tostring(globalid) )
    if debug then
        c8y.tabledump(ret)
    end
  return ret
end

-------------------------                                                                                                                                   
-- c8y_inventory.get_XX(tab)                                                                                                                                          
-------------------------                                                                                                                                   
function c8y_inventory.get_owner(tab) 
  return tab.owner
end

function c8y_inventory.id(tab) 
  return tab.id
end

function c8y_inventory.get_childdevices(tab) 
  return tab.childDevices.self
end

function c8y_inventory.get_deviceparents(tab) 
  return tab.deviceParents.self
end

function c8y_inventory.get_childassets(tab) 
  return tab.childAssets.self
end

function c8y_inventory.get_assetparents(tab) 
  return tab.assetParents.self
end

function c8y_inventory.get_lastupdate(tab) 
  return tab.lastUpdated
end

function c8y_inventory.get_name(tab) 
  return tab.name
end

function c8y_inventory.get_fragments(tab) 
  return tab.fragments
end

-------------------------                                                                                                                                   
-- c8y_inventory.get_inventory(url)                                                                                                                                          
-------------------------                                                                                                                                   
-- ret=c8y_inventory.get_inventory('http://demo.cumulocity.com/inventory/managedObjects/116000')                                                                                                                                          
-- ret=c8y_inventory.get_inventory('http://demo.cumulocity.com/inventory/managedObjects/2664700')                                                                                                                                          
-------------------------                                                                                                                                   
function c8y_inventory.get_inventory(url)
 local self=nil
 local deviceParents=nil
 local assetParents=nil
 local childDevices=nil
 local childAssets=nil
 local tab = c8y_inventory.get_byurl( url )
 if debug then print('c8y_inventory.get_inventory') end
 if tab ~= nil then 
   self=tab.self
   if debug then
       c8y.tabledump(tab)
   end
   if tab.childDevices and tab.childDevices.references then 
        for i =1,#tab.childDevices.references do
          obj=tab.childDevices.references[i]
          if obj and obj.managedObject and obj.managedObject.self then
 	    childDevices=obj.managedObject.self 
 	    ret=c8y_inventory.get_inventory(obj.managedObject.self)
 	    if ret and ret.childDevices then
 	       childDevices={childDevices,ret.childDevices} 
 	    end
 	  end
 	end
   end 
   if tab.childAssets and tab.childAssets.references then 
        for i =1,#tab.childAssets.references do
          obj=tab.childAssets.references[i]
          if obj and obj.managedObject and obj.managedObject.self then
 	    childAssets=obj.managedObject.self 
 	    ret=c8y_inventory.get_inventory(obj.managedObject.self)
 	    if ret and ret.childAssets then
 	       childDevices={childAssets,ret.childAssets} 
 	    end
 	  end
 	end
   end 
   if tab.deviceParents and tab.deviceParents.references then
        for i =1,#tab.deviceParents.references do
          obj=tab.deviceParents.references[i]
          if obj and obj.managedObject and obj.managedObject.self then
 	    deviceParents={ obj.managedObject.self } 
 	    ret=c8y_inventory.get_inventory(obj.managedObject.self)
 	    if ret and ret.deviceParents then
 	       deviceParents={deviceParents,ret.deviceParents} 
 	    end
 	  end
 	end
   end
   if tab.assetParents and tab.assetParents.references then
        for i =1,#tab.assetParents.references do
          obj=tab.assetParents.references[i]
          if obj and obj.managedObject and obj.managedObject.self then
 	    assetParents={ obj.managedObject.self } 
 	   ret=c8y_inventory.get_inventory(obj.managedObject.self)
 	   if ret and ret.assetParents then
 	       assetParents={assetParents,ret.assetParents} 
 	   end
 	  end
 	end
   end
 end
 return { self=self, deviceParents=deviceParents , assetParents=assetParents, childDevices=childDevices, childAssets=childAssets } 
end




-------------------------
-- c8y_inventory.get_byurl
-------------------------
-- c8y_inventory.get_byurl('http://demo.cumulocity.com/inventory/managedObjects/114200')
-------------------------
function c8y_inventory.get_byurl(self)
    local ret
    if debug then print('c8y_inventory.get_byurl') end
    ret = c8y.get( c8y_inventory.root.type,self )
    if debug then
        c8y.tabledump(ret)
    end
  return ret
end


-------------------------                                                                                                                                   
-- c8y_inventory.get_managedobjects                                                                                                                                          
-------------------------                                                                                                                                   
--@url
-------------------------
function c8y_inventory.get_managedobjects(url) 
   local ret
   local ret0={}
   local totalPages=1
   local page=1
   if debug then print('c8y_inventory.get_managedobjects') end
   if not url then 
      url=c8y_inventory.managedobjects.resource
   end
  
    if debug then
       print( '------> : '..url )
    end
    ret = c8y.get( c8y_inventory.root.type,url )
    totalPages=ret.totalPages
    if totalPages == nil then totalPages=1 end
    if debug and ret then
        c8y.tabledump(ret)
    end
    ret0={ret}
    for page =1,totalPages do 
       if not ( ret and ret.next ) then break end
       print( '------> ret.next: '..ret.next )
       ret = c8y.get( c8y_inventory.root.type,ret.next )
       if debug and ret then
          c8y.tabledump(ret)
       end
       ret0={ret0,ret}
    end
    return ret0
end

-------------------------                                                                                                                                   
--c8y_inventory.get_managedObjectsForType                                                                                                                                          
-------------------------                                                                                                                                   
--@type
-------------------------
function c8y_inventory.get_managedObjectsForType(type) 
  if debug then print('c8y_inventory.get_managedObjectsForType') end
  url=c8y_inventory.managedobjects.resource..'?type='..type
  ret=c8y_inventory.get_managedobjects(url) 
  return ret
end

-------------------------                                                                                                                                   
--c8y_inventory.get_managedObjectsForFragmentType                                                                                                                                          
-------------------------                                                                                                                                   
--@fragmentType
-------------------------
function c8y_inventory.get_managedObjectsForFragmentType(fragmentType) 
  if debug then print('c8y_inventory.get_managedObjectsForFragmentType') end
  url=c8y_inventory.managedobjects.resource..'?fragmentType='..fragmentType
  ret=c8y_inventory.get_managedobjects(url) 
  return ret
end

-------------------------                                                                                                                                   
--c8y_inventory.get_managedObjectsForListOfIds                                                                                                                                          
-------------------------                                                                                                                                   
--@ids
-------------------------
function c8y_inventory.get_managedObjectsForListOfIds(ids) 
  if debug then print('c8y_inventory.get_managedObjectsForListOfIds') end
  url=c8y_inventory.managedobjects.resource..'?ids='..ids
  ret=c8y_inventory.get_managedobjects(url) 
  return ret
end


-------------------------                                                                                                                                   
--c8y_inventory.get_managedObjectsForText                                                                                                                                          
-------------------------                                                                                                                                   
--@text
-------------------------
function c8y_inventory.get_managedObjectsForText(text) 
  if debug then print('c8y_inventory.get_managedObjectsForText') end
  url=c8y_inventory.managedobjects.resource..'?text='..text
  ret=c8y_inventory.get_managedobjects(url) 
  return ret
end

-------------------------
--c8y_inventory.create()
-------------------------
--@obj={name="name",type="type"}
-------------------------
function c8y_inventory.create(obj) 
    local ret
    if debug then print('c8y_inventory.create') end
    ret = c8y.post( c8y_inventory.managedobjects.type,c8y_inventory.managedobjects.resource , obj )
    if debug then
        c8y.tabledump(ret)
    end
    return ret
end

-------------------------
--c8y_inventory.update()
-------------------------
--@obj={c8y_IsDevice={},com_cumulocity_model_Agent={}}
--@obj={c8y_SupportedMeasurements={'c8y_SignalStrength'}}
--@obj={c8y_SupportedMeasurements={"c8y_SignalStrength", "c8y_Battery" }}
--@obj={c8y_SupportedOperations={'c8y_Restart','c8y_Configuration','c8y_Software','c8y_Firmware'}}
-------------------------
function c8y_inventory.update(globalid,obj) 
    local ret
    if debug then print('c8y_inventory.update') end
    ret = c8y.put( c8y_inventory.managedobjects.type,c8y_inventory.managedobjects.resource..'/'..tostring(globalid),obj)
    if debug then
        c8y.tabledump(ret)
    end
    return ret
end

-------------------------
--c8y_inventory.delete()
-------------------------
--@url
-------------------------
function c8y_inventory.delete(url) 
  local ret
  ret = c8y.delete( c8y_inventory.managedobjects.type,url)
  if debug then print('c8y_inventory.delete') end
  if debug then
        c8y.tabledump(ret)
  end
  return ret
end

-------------------------
--c8y_inventory.deletebyid()
-------------------------
--@id
-------------------------
function c8y_inventory.deletebyid(id) 
  local ret
  if debug then print('c8y_inventory.deletebyi') end
  url=c8y_inventory.managedobjects.resource..'/'..tostring(id)
  ret = c8y_inventory.delete( url)
  return ret
end


-------------------------
--c8y_inventory.create()
-------------------------
--@obj={name="name",type="type"}
-------------------------
function c8y_inventory.create(obj) 
    local ret
    if debug then print('c8y_inventory.create') end
    ret = c8y.post( c8y_inventory.managedobjects.type,c8y_inventory.managedobjects.resource , obj )
    if debug then
        c8y.tabledump(ret)
    end
    return ret
end


-------------------------
--c8y_inventory.object2childasset(obj_id,child_id)
-------------------------
--@obj_id:
--@child_id:
-------------------------
function c8y_inventory.object2childasset(obj_id,child_id) 
  local ret
  local obj={}
  if debug then print('c8y_inventory.object2childasset') end
  obj={managedObject={self=c8y.host..c8y_inventory.managedobjects.resource..'/'..tostring(child_id)}}
  ret = c8y.post( c8y_inventory.managedobjectreference.type,c8y_inventory.managedobjects.resource..'/'..tostring(obj_id)..'/childAssets' , obj )
  if debug then
        c8y.tabledump(ret)
  end
  return ret
end

-------------------------
--c8y_inventory.object2childdevice(obj_id,child_id)
-------------------------
--@obj_id:
--@child_id:
-------------------------
function c8y_inventory.object2childdevice(obj_id,child_id) 
  local ret
  local obj={}
  if debug then print('c8y_inventory.object2childdevice') end
  obj={managedObject={self=c8y.host..c8y_inventory.managedobjects.resource..'/'..tostring(child_id)}}
  ret = c8y.post( c8y_inventory.managedobjectreference.type,c8y_inventory.managedobjects.resource..'/'..tostring(obj_id)..'/childDevices' , obj )
  if debug then
        c8y.tabledump(ret)
  end
  return ret
end

-------------------------
--c8y_inventory.delete_object2childdevice(obj_id,child_id)
-------------------------
--@obj_id:
--@child_id:
-------------------------
function c8y_inventory.delete_object2childdevice(obj_id,child_id) 
  local ret
  local obj={}
  if debug then print('c8y_inventory.delete_object2childdevice') end
  ret = c8y.delete( c8y_inventory.managedobjectreference.type,c8y_inventory.managedobjects.resource..'/'..tostring(obj_id)..'/childDevices/'..tostring(child_id))
  if debug then
        c8y.tabledump(ret)
  end
  return ret
end


-------------------------                                                                                                   
--test()                                                                                                                    
-------------------------                                                                                                   
if debug then                                                                                                               
require 'c8y_identity'
function c8y_inventory.test()
  local globalid,self
  local FragmentType
  local type
  --
  --Init
  --
  FragmentType='c8y_RequiredAvailability'
  --
  --Create device test
  --
  ret=c8y_inventory.create({name='test1'})
  c8y_restful.tabledump(ret)
  globalid1=c8y_inventory.get_id(ret.location)
  ret=c8y_inventory.create({name='test2'})
  c8y_restful.tabledump(ret)
  globalid2=c8y_inventory.get_id(ret.location)
  c8y_inventory.update(globalid1,{c8y_IsDevice={},com_cumulocity_model_Agent={}})
  c8y_inventory.update(globalid2,{c8y_IsDevice={},com_cumulocity_model_Agent={}})
  c8y_inventory.update(globalid1,{FragmentType={responseInterval=1}})
  c8y_inventory.update(globalid2,{FragmentType={responseInterval=1}})
  c8y_identity.set_externalid(globalid1,'test1','test1')
  c8y_identity.set_externalid(globalid2,'test2','test2') 
  c8y_inventory.object2childasset(globalid1,globalid2)
  c8y_inventory.object2childdevice(globalid1,globalid2)
  c8y_inventory.get_byid(globalid1)
  c8y_inventory.get_byid(globalid2)
  
  c8y_inventory.get_managedObjectsForType('Test1')
  c8y_inventory.get_managedObjectsForFragmentType('Test1')
  c8y_inventory.get_managedObjectsForText('Test1')
  --c8y_inventory.deletebyid(globalid1)
  --c8y_inventory.deletebyid(globalid2)
  c8y_inventory.get_managedobjects()
end
end

return c8y_inventory
