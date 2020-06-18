local wrapper = {}
local mapname
local dimension = 0
local mainResource = "rp"
wrapper.objects = {}
wrapper.timers = {}
wrapper.events = {}
wrapper.txd = {}
wrapper.marker = {}
wrapper.xmlFiles = {}
wrapper.models = {}
wrapper.sounds = {}
wrapper.data = {}
wrapper.peds = {}
wrapper.commands = {}
wrapper.binds = {}
wrapper.vehicle = {}
wrapper.textures = {}
wrapper.shader = {}
local _createObject = createObject 
local _setTimer = setTimer
local _addEventHandler = addEventHandler
local _engineLoadTXD = engineLoadTXD
local _engineImportTXD = engineImportTXD
local _createMarker = createMarker
local _xmlLoadFile = xmlLoadFile
local _engineSetModelLODDistance = engineSetModelLODDistance
local _engineReplaceCOL = engineReplaceCOL
local _engineLoadCOL = engineLoadCOL
local _engineReplaceModel = engineReplaceModel
local _engineLoadDFF = engineLoadDFF
local _setElementData = setElementData
local _playSound = playSound
local _addCommandHandler = addCommandHandler
local _bindKey = bindKey
local _createPed = createPed
local _createVehicle = createVehicle
local _dxCreateTexture = dxCreateTexture
local _dxCreateShader = dxCreateShader
local _dxCreateScreenSource = dxCreateScreenSource
local _fileDelete = fileDelete

outputDebugString("PROJECT_ONE Wrapper starting...")

function dxCreateShader(path, ...)
	local path = ":rp/downloaded/"..mapname.."/"..path
	local tex = _dxCreateShader(path, ...)
	table.insert(wrapper.shader, tex)
	return tex
end

function engineImportTXD(texture, model)
	table.insert(wrapper.models, model)
	return _engineImportTXD(texture, model)	
end

function createObject(...)
	local obj = _createObject(...)
	setElementDimension(obj, dimension)
	table.insert(wrapper.objects, obj)
	return obj
end

function setTimer(...)
	local timer = _setTimer(...)
	table.insert(wrapper.timers, timer)
	return timer
end

function addEventHandler(eventName, eventSource, eventFunc)
	if eventName == "onClientResourceStart" then
		_setTimer(eventFunc, 1500, 1)
	end
	table.insert(wrapper.events, {eventName, eventSource, eventFunc})
	_addEventHandler(eventName, eventSource, eventFunc)
end

function engineLoadTXD (path, filter)
	local path = ":rp/downloaded/"..mapname.."/"..path
	local txd = _engineLoadTXD(path, filter)
	return txd
end

function createMarker(...)
	local obj = _createMarker(...)
	setElementDimension(obj, dimension)
	table.insert(wrapper.marker, obj)
	return obj
end

function xmlLoadFile (path)
	local path = ":rp/downloaded/"..mapname.."/"..path
	local xml = _xmlLoadFile(path)
	table.insert(wrapper.xmlFiles, xml)
	return xml
end

function engineSetModelLODDistance(model, distance)
	if model == 2221 or model == 2222 or model == 2223 then return end
	table.insert(wrapper.models, model)
	return _engineSetModelLODDistance(model, distance)
end

function engineLoadCOL (path, filter)
	local path = ":rp/downloaded/"..mapname.."/"..path
	local txd = _engneLoadCOL(path, filter)
	return txd
end

function engineReplaceModel (dff, model)
	table.insert(wrapper.models, model)
	return _engineReplaceModel(dff, model)
end

function engineLoadDFF (path, filter)
	local path = ":rp/downloaded/"..mapname.."/"..path
	local txd = _engineLoadDFF(path, filter)
	return txd
end

function setElementData(element, key, value)
	table.insert(wrapper.data, {element,key,value})
	return _setElementData(element,key,value)
end

function playSound(soundPath, looped, throttle)
	local path = ":rp/downloaded/"..mapname.."/"..soundPath
	local sound = _playSound(path, looped, throttle)
	table.insert(wrapper.sounds, sound)
	return sound
end

function addCommandHandler(command, func)
	table.insert(wrapper.commands, {command, func})
	return _addCommandHandler(command, func)
end

function bindKey(key,state,func)
	table.insert(wrapper.binds, {key,state,func})
	return _bindKey(key,state,func)
end

function createPed(...)
	local ped = _createPed(...)
	setElementDimension(ped, dimension)
	table.insert(wrapper.peds, ped)
	return ped
end

function createVehicle(...)
	local veh = _createVehicle(...)
	setElementDimension(veh, dimension)
	table.insert(wrapper.vehicle, veh)
	return veh
end

function dxCreateTexture(path, ...)
	local path = ":rp/downloaded/"..mapname.."/"..path
	local tex = _dxCreateTexture(path, ...)
	table.insert(wrapper.textures, tex)
	return tex
end

function dxCreateScreenSource(...)
	local tex = _dxCreateScreenSource(...)
	table.insert(wrapper.textures, tex)
	return tex
end

function fileDelete(path, ...)
	local path = ":rp/downloaded/"..mapname.."/"..path
	return _fileDelete(path, ...)
end

function loadClientScript(file, resourceName, dim)
	dimension = dim
	mapname = resourceName
	
	if fileExists(":rp/downloaded/"..resourceName.."/"..file) then
		local file = fileOpen(":rp/downloaded/"..resourceName.."/"..file)
		local fileContent = fileRead(file, fileGetSize(file))
		local loadedString = loadstring(fileContent)
		fileClose(file)
		-- Execute the loaded string.
		loadedString()
	end
end
addEvent("RP:Wrapper:load", true)
_addEventHandler("RP:Wrapper:load", root, loadClientScript)

function unloadClientScripts()
	for key, value in ipairs(wrapper.data) do
		setElementData(value[1], value[2], nil)
	end	
	for key, value in ipairs(wrapper.objects) do
		if isElement(value) then
			destroyElement(value)
		end
	end
	for key, value in ipairs(wrapper.timers) do
		if isTimer(value) then
			killTimer(value)
		end
	end
	for key, value in ipairs(wrapper.events) do
		removeEventHandler(value[1], value[2], value[3])
	end
	for key, value in ipairs(wrapper.txd) do
		if isElement(value) then
			destroyElement(value)
		end
	end
	for key, value in ipairs(wrapper.marker) do
		if isElement(value) then
			destroyElement(value)
		end
	end
	for key, value in ipairs(wrapper.xmlFiles) do
		xmlUnloadFile(value)
	end
	for key, value in ipairs(wrapper.models) do
		engineRestoreModel(value)
	end
	for key, value in ipairs(wrapper.sounds) do
		stopSound(value)
	end
	for key, value in ipairs(wrapper.peds) do
		if isElement(value) then
			destroyElement(value)
		end
	end
	for key, value in ipairs(wrapper.commands) do
		removeCommandHandler(value[1], value[2])
	end
	for key, value in ipairs(wrapper.binds) do
		unbindKey(value[1], value[2], value[3])
	end
	for key, value in ipairs(wrapper.vehicle) do
		if isElement(value) then
			destroyElement(value)
		end
	end
	for key, value in ipairs(wrapper.textures) do
		if isElement(value) then
			destroyElement(value)
		end
	end
	wrapper.objects = {}
	wrapper.timers = {}
	wrapper.events = {}
	wrapper.txd = {}
	wrapper.marker = {}
	wrapper.xmlFiles = {}
	wrapper.models = {}
	wrapper.sounds = {}
	wrapper.data = {}
	wrapper.peds = {}
	wrapper.commands = {}
	wrapper.binds = {}
	wrapper.vehicle = {}
	wrapper.textures = {}	
	wrapper.shader = {}
end
addEvent("RP:Wrapper:reset", true)
_addEventHandler("RP:Wrapper:reset", root, unloadClientScripts)