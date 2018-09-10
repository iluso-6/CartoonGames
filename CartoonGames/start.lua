---------------------------------------------------------------------------------
--
-- testscreen1.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
local M = require("soundModule")
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local buttonA
local buttonB
local buttonC
local buttonD

local imageAnimals
local imageRabbit
local imageFrog
local imageSong
local buttonPop = {}


--local jigsaw = {"images/people2/Angel.png" , "images/people2/Maid.png" , "images/people2/Leprechaun.png" , "images/people2/Prince.png" , "images/people2/Pirate.png" , "images/people2/Policeman.png" , "images/people2/Princess.png" , "images/people2/Santa.png" , "images/people2/Elf.png" , "images/people2/Scientist.png" }

---local people = {"images/people/Artist.png" , "images/people/Mime.png" , "images/people/Ninja.png" , "images/people/Robber.png" , "images/people/Clown.png" , "images/people/Vampire.png" , "images/people/Superhero.png" , "images/people/Soldier.png" , "images/people/Student.png" , "images/people/Astronaut.png" }


	musicTrack = M.intro


function buttonPop(event)
		if ( event.phase == "began" ) then
		elseif (event.phase == "ended") then

		local t = event.target.id
			 playSFX( M.squish )
		 
			 transition.to( t, { time=100 ,xScale=1.2,yScale=1.2,transition=easing.outExpo, onComplete=function() 
			 transition.to( t, { time=80 ,xScale=1,yScale=1,transition=easing.inExpo })
			 end} )
			 
		end
	return true
end


-- Touch event listener for background image
local function handleButtonEvent( event )

		local options =
		{	page = "cut3",
			effect = "slideLeft",
			time = 1000,
			params = { }
		}

	if event.phase == "ended" then
		playSFX(M.backwards)
		local t = (event.target.id)
		timer.performWithDelay(200,
		function()
			if(t=='animals')then
			obj=imageAnimals
			options.page="cut3"
			elseif(t=='rabbit')then
			obj=imageRabbit
			options.page="rabbit_new"
			elseif(t=='frog')then
			options.page="frogger"
			obj=imageFrog
			elseif(t=='song')then
			options.page="song"
			obj=imageSong
			end
	transition.to(obj,{time=700, rotation=360, onComplete=function()
	obj.rotation=0
	timer.performWithDelay(100,function() storyboard.gotoScene( options.page , options )  end)
	
				end})
		end )
		return true
	end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	local background = display.newImageRect( "images/background.png",W,H )
		  background.x = midW
		  background.y = midH
		  screenGroup:insert( background )
		  
	  
		buttonA = widget.newButton
{
    defaultFile = "images/mushroomPurple.png",
    overFile = "images/mushroomPurpleOver.png",
	id = 'animals',
    onEvent = handleButtonEvent
}
	buttonA.x = midW-350
	buttonA.y = H-170
		screenGroup:insert( buttonA )
		
	imageAnimals = display.newImageRect("images/screenCut.png",256,256)
	imageAnimals:scale(0.8,0.8)
	imageAnimals.x = buttonA.x
	imageAnimals.y = midH-80
	imageAnimals.id=buttonA
	imageAnimals:addEventListener( "touch" , buttonPop )
		screenGroup:insert( imageAnimals )
----------------------------------------
	
	buttonB = widget.newButton
{
    defaultFile = "images/mushroomYellow.png",
    overFile = "images/mushroomYellowOver.png",
	id = 'rabbit',
    onEvent = handleButtonEvent
}
	buttonB.x =  midW-118
	buttonB.y = H-170
		screenGroup:insert( buttonB )
		
	imageRabbit = display.newImageRect("images/screenRabbit.png",256,256)
	imageRabbit:scale(0.8,0.8)
	imageRabbit.x = buttonB.x
	imageRabbit.y = midH-80
	imageRabbit.id=buttonB
	imageRabbit:addEventListener( "touch" , buttonPop )
		screenGroup:insert( imageRabbit )	
-----------------------------------------	
	
	buttonC = widget.newButton
{
    defaultFile = "images/mushroomBlue.png",
    overFile = "images/mushroomBlueOver.png",
	id = 'frog',
    onEvent = handleButtonEvent
}
	buttonC.x = midW+118
	buttonC.y = H-170
		screenGroup:insert( buttonC )
		
	imageFrog = display.newImageRect("images/screenFrog.png",256,256)
	imageFrog:scale(0.8,0.8)
	imageFrog.x = buttonC.x
	imageFrog.y = midH-80
	imageFrog.id=buttonC
	imageFrog:addEventListener( "touch" , buttonPop )
		screenGroup:insert( imageFrog )
-----------------------------------------	
	
	buttonD = widget.newButton
{
    defaultFile = "images/mushroomRed.png",
    overFile = "images/mushroomRedOver.png",
	id = 'song',
    onEvent = handleButtonEvent
}
	buttonD.x = midW+350
	buttonD.y = H-170
		screenGroup:insert( buttonD )
		
	imageSong = display.newImageRect("images/screenSong.png",256,256)
	imageSong:scale(0.8,0.8)
	imageSong.x = buttonD.x
	imageSong.y = midH-80
	imageSong.id=buttonD
	imageSong:addEventListener( "touch" , buttonPop )
		screenGroup:insert( imageSong )

		
	local back = widget.newButton
{
    defaultFile = "images/mushroomLeft.png",
    overFile = "images/mushroomLeftOver.png",
	width=120,
	height=120,
    onRelease = function()
	playSFX(M.backwards)
	timer.performWithDelay(400,function()
	storyboard.gotoScene( "intro" , { time=1000, effect = "slideRight" } ) end
	)
	end
}
	back.x = 50
	back.y = H-50
	screenGroup:insert( back )
	
	
	
	end
	
	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

if(musicIsPlaying)then
--playMusic("play")
end

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