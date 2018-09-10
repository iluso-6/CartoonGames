-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
local splash = require("splash")
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local widget = require("widget") 
local M
local selected = false

local loadGoto

----Globals

	W = display.contentWidth
	H = display.contentHeight
	midW = display.contentWidth*0.5
	midH = display.contentHeight*0.5

	musicIsPlaying = false
	sfxIsPlaying = true
	audio.reserveChannels(1)
	sndChanMusic = 1
	
	splash.startSplash()
	
		progressView = widget.newProgressView
		{
			left = 0,
			top = 0,
			width = 300,
			isAnimated = true
		}

		progressView.x = midW
		progressView.y = midH+60


function updateProgress(val)
progressView:setProgress( val )	
print( val )
	
end
	

function loadGoto()


M = require("soundModule")

timer.performWithDelay(1000, function()
storyboard.gotoScene( "intro" )
end)
end	

     updateProgress(0.1)


local modal = display.newGroup()
local modalOn = display.newImageRect("images/modalOn.png",300,300)
modal:insert(modalOn)

local modalOff = display.newImageRect("images/modalOff.png",300,300)
modal:insert(modalOff)


local function modalControl(event)

	if(event.phase=="began")then
		display.getCurrentStage():setFocus( event.target )
	elseif(event.phase=="ended")then
		if(selected == false)then
				selected = true
		if(musicIsPlaying==true)then
			modalOff.isVisible=true
			modalOn.isVisible=false
			musicIsPlaying = false
			playMusic("stop")
		elseif(musicIsPlaying==false)then
			modalOn.isVisible=true
			modalOff.isVisible=false
			musicIsPlaying = true
			playMusic("play" )
		end

		transition.to(modal,{delay=1000, time=500,transition= easing.inBounce, xScale=0.2,yScale=0.2,onComplete=function() modal.isVisible=false ;  selected = false end})	
		else

		end
	display.getCurrentStage():setFocus(nil)
	return true
	end
end

modal.x = midW
modal.y = midH
modal.isVisible=false
modal:scale(0.2,0.2)


local function onKeyEvent( event )
	local current = storyboard.getCurrentSceneName()
	if(current~='intro')then
		if(musicIsPlaying==true)then
		modalOn.isVisible=true
		modalOff.isVisible=false
		elseif(musicIsPlaying==false)then
		modalOn.isVisible=false
		modalOff.isVisible=true
		end
    if (event.keyName == "menu" and event.phase=="up" and modal.isVisible==false) then
			modal.isVisible=true
			transition.to(modal,{time=500,transition= easing.outBounce, xScale=1,yScale=1})
			
		modal:addEventListener("touch" , modalControl )
	elseif (event.keyName == "menu" and event.phase=="up" and modal.isVisible==true ) then
			musicIsPlaying = musicIsPlaying 
	transition.to(modal,{ time=500,transition= easing.inBounce, xScale=0.2,yScale=0.2,onComplete=function()
	modal.isVisible=false
		modal:removeEventListener("touch" , modalControl )
	end})
	
        return true
    end

    return false
	end
end

Runtime:addEventListener( "key", onKeyEvent );	
	
function playSFX(audioHandle, opt)

	local options = opt or {}

	local callback = options.onComplete or {}
	local chanUsed = nil
	if sfxIsPlaying then
		chanUsed = audio.play( audioHandle, { onComplete=callback } )
	end
		return chanUsed
end

local function resetMusic(e)

	if e.completed == false and e.phase == "stopped" then
		audio.setVolume ( 1, { channel=sndChanMusic } )
		audio.rewind ( musicTrack )
	end
end

function playMusic(action, trackType )
	if action == "play" then
				musicTrack = trackType or musicTrack
		if musicIsPlaying and  musicTrack then
				local isChannel1Active = audio.isChannelActive( sndChanMusic )
				if isChannel1Active then
				audio.stop( { channel=sndChanMusic } )
				end
		
			audio.play( musicTrack, { channel=sndChanMusic, loops=-1, onComplete=resetMusic } )
			
		end
	elseif action == "stop" then
		audio.stop ( sndChanMusic )
		audio.rewind ( sndChanMusic )
	elseif action == "fade" then
		audio.fadeOut ( {channel=sndChanMusic, time=2000, onComplete=resetMusic } )
	end
end


		
		
        splash.setLoader( loadGoto );
		
  



--[[
		--Uncomment to monitor app's lua memory/texture memory usage in terminal...
local function garbagePrinting()
	collectgarbage("collect")
    local memUsage_str = string.format( "memUsage = %.3f KB", collectgarbage( "count" ) )
    print( memUsage_str )
    local texMemUsage_str = system.getInfo( "textureMemoryUsed" )
    texMemUsage_str = texMemUsage_str/1000
    texMemUsage_str = string.format( "texMemUsage = %.3f MB", texMemUsage_str )
    print( texMemUsage_str )
end

Runtime:addEventListener( "enterFrame", garbagePrinting )

--]]