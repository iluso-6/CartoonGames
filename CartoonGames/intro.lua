
display.setStatusBar( display.HiddenStatusBar )
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local widget = require("widget")
local splash = require("splash")
local M = require("soundModule")
local musicTxton

musicTrack = M.intro
	
local function handleButtonEvent(event)

 local t = event.target
	if ( "ended" == event.phase ) then
	playSFX(M.forewards)
	timer.performWithDelay(1000, function() storyboard.gotoScene( "start" , { time=1000, effect = "slideLeft" } ) end )
	
	end
end


			------------------
function scene:createScene( event )
	local screenGroup = self.view

    local loadingbackground = display.newImageRect( "images/back.png" ,W ,H )
    loadingbackground.x = midW
    loadingbackground.y = midH
	screenGroup:insert(loadingbackground)

	local logo = display.newImageRect("images/logo.png",100,100)
	logo.x = 80
	logo.y = 80
	screenGroup:insert( logo )
		
		local musicTxt = widget.newButton
	{
		defaultFile = "images/musicOff.png",
		overFile = "images/musicOn.png",
		width = 300,
		height = 125,
		onRelease = function() 
		musicIsPlaying = not musicIsPlaying
			if(musicIsPlaying)then
			musicTxton.isVisible=true
			musicIsPlaying = true
			playMusic("play")
			else
			musicIsPlaying = false
			musicTxton.isVisible=false
			playMusic("stop")
			end
		end
	}

	musicTxt.x = midW
	musicTxt.y = H-80
	screenGroup:insert(musicTxt)
		
	musicTxton = display.newImageRect( "images/musicOn.png",300,125 )
	musicTxton.x = midW
	musicTxton.y = H-80
	if(musicIsPlaying == false)then musicTxton.isVisible=false end
	screenGroup:insert(musicTxton)
	
	local button = widget.newButton
{
    defaultFile = "images/mushroomRight.png",
    overFile = "images/mushroomRightOver.png",
    onEvent = handleButtonEvent
}
	button.x = W-246
	button.y = midH+100
	button:scale(0.2,0.2)
	button.isVisible = false
	screenGroup:insert(button)
	
	splash.stopSplash()

	timer.performWithDelay( 1000, function() playSFX(M.squishMain)  button.isVisible = true end )
	transition.to(button,{delay=1000,time=700,xScale=1,yScale=1,rotation=370, transition=easing.outBounce,onComplete=function()
	button.rotation=360 
	
	if(progressView)then
	display.remove(progressView)
	progressView = nil
	end	
	
 end})


end
	
function scene:enterScene( event )
local prior_scene = storyboard.getPrevious()

storyboard.removeAll()
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
storyboard.removeAll()

	

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene
