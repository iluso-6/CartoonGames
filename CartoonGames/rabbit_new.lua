local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require("widget")
local CBE=require("CBEffects.Library")
local movieclip = require("movieclipMod")
local M = require("soundModule")
local tm = require("transitionManager")
tm = tm.new()

local contentFiles = {"images/5.png" , "images/4.png" , "images/3.png" , "images/2.png" , "images/1.png"  }

musicTrack = M.circus

local rand = (math.random)

local hat1
local hat2
local hat3
local hat2open

local hats = display.newGroup()
local hatLift  = 110
local carrotPos = { -240, -160, 0, 150 }	
local carrotCount = 1
local previousX
local wand
local curtains
local confetti
local closeTimer

local moveSpeed = 800
local totalMoves = 5

local checkMovesLeft = {}
local revealBall = {}
local randomHatMove = {}


local function hurray() 

	confetti=CBE.NewVent{
		preset="confetti",
	--	posRadius=120, -- Appear randomly inside of a radius of 220 px
	--	lifeSpan=500,
	--	fadeInTime=200,
	--	startAlpha=0,
		perEmit=4,
		emitDelay=100,
		build=function()
			local size=rand(15, 30)
			return display.newImageRect( "CBEffects/star_particle1.png" , size, size)
			
		end,
		physics={
			velocity=2 -- Not moving
		}
	}
	confetti:start()
	
end

local function openShow(obj)
	if(obj=="open")then
	
			curtains:setSpeed(.1)
			curtains:play{ startFrame=1, endFrame=5, loop=1 }
	elseif(obj=="close")then
	
			curtains:stopAtFrame( 5 )
			closeTimer=timer.performWithDelay(5000, function()
			curtains:setSpeed(.1)
			curtains:reverse{ startFrame=5, endFrame=1, loop=1 }
											end )
	end
end	

local function wandStarted(event)	
	if(event.phase=="ended")then
	
		playSFX(M.fairyWand)
		wand:setEnabled( false ) 
		
		totalMoves = 5
		
		playSFX(M.down)
		hat2.isVisible=true
		hat2open.isVisible=false
		playSFX(M.mystery)
		tm:add(hat2, {delay=1200,time = 1200, y = hat2.y+hatLift , transition=easing.outExpo, onComplete = randomHatMove})
		
	end
end	



function scene:createScene( event )
	local screenGroup = self.view	
	
	curtains = movieclip.newAnim( contentFiles )
	
	local board = display.newImage('images/board.png')
	board.x = midW
	board.y = H-120
	board:setFillColor(175,105,23)
	screenGroup:insert( board )
	
	local bg = display.newImageRect('images/stars.jpg',W-100,H-150)
	bg.x = midW
	bg.y = midH-50
	bg:setFillColor(136,29,219)
	screenGroup:insert( bg )
	
	hat2open = display.newImage('images/hat_open.png')	
	hat2open.x = midW
	hat2open.y = midH-hatLift
	screenGroup:insert( hat2open )
	
	local rabbit = display.newImageRect('images/rabbit.png',140,140)
	rabbit.x = hat2open.x
	rabbit.y = hat2open.y+140
	screenGroup:insert( rabbit )
	
	hat1 = display.newImage('images/hat.png')
	hat1.x = midW-280
	hat1.y = midH
	
	hat2 = display.newImage('images/hat.png')
	hat2.x = hat2open.x
	hat2.y = hat2open.y
	hat2.name = 'hat2'
	hat2.isVisible=false
	
	hat3 = display.newImage('images/hat.png')
	hat3.x = midW+280
	hat3.y = midH
	
	hats:insert(hat1)
	hats:insert(hat2)
	hats:insert(hat3)
	screenGroup:insert( hats )
	
	wand = widget.newButton
{
    defaultFile = "images/wand.png",
    overFile = "images/wandOver.png",
	height = 125,
	width = 600,
    onRelease = wandStarted
}
	wand:setReferencePoint(display.CenterReferencePoint)
	wand.x = midW
	wand.y = H-100
	screenGroup:insert( wand )
	
	local carrot = display.newImageRect('images/carrot.png',180,180)
	carrot.x = wand.x+carrotPos[1]
	carrot.y = wand.y-20
	previousX = carrot.x
	screenGroup:insert( carrot )
	
	curtains:setReferencePoint(display.CenterReferencePoint)
	curtains.x = midW
	curtains.y = midH

	curtains.width = W
	curtains.height = H
	screenGroup:insert( curtains )
	
	local back = widget.newButton
{
    defaultFile = "images/mushroomLeft.png",
    overFile = "images/mushroomLeftOver.png",
	width=120,
	height=120,
    onRelease = function()
	playSFX(M.backwards)
	timer.performWithDelay(400,function()
	storyboard.gotoScene( "start" , { time=1000, effect = "slideRight" } ) end
	)
	end
}
	back.x = 50
	back.y = H-50
	screenGroup:insert( back )
	
	
	
function randomHatMove()
	local randm = math.floor(math.random() * 2) + 1
	
	local shell1 = hats[randm]
	local shell2 

	if(shell1 ~= 3) then
		shell2 = hats[randm + 1]
	elseif(shell1 ~= 1) then
		shell2 = hats[randm - 1]
	end
	
	rabbit.isVisible = false
	
	totalMoves = totalMoves -1
	
	tm:add(shell1, {time = moveSpeed, x = shell2.x, y = shell2.y})
	tm:add(shell2, {time = moveSpeed, x = shell1.x, y = shell1.y, onComplete = checkMovesLeft})
end


function checkMovesLeft()
	if(totalMoves > 0) then
		randomHatMove()
	else
		hat1:addEventListener('touch', revealBall)
		hat2:addEventListener('touch', revealBall)
		hat3:addEventListener('touch', revealBall)
		
	end
end

function revealBall:touch(e)
	if(e.phase=='ended')then
	hat1:removeEventListener('touch', revealBall)
	hat2:removeEventListener('touch', revealBall)
	hat3:removeEventListener('touch', revealBall)
	
	-- Move Ball to correct position
	
	rabbit.x = hat2.x
	rabbit.y = hat2.y+20
	rabbit.isVisible = true

	-- Give credits if correct guess
	
	if(e.target.name == 'hat2' and carrotCount<5) then
		carrotCount = carrotCount +1
	else
--wrong
		if(carrotCount>1)then
			carrotCount = carrotCount -1
		end	
	end
	playSFX(M.up)
	hat2open.x = hat2.x
	tm:add(hat2, {delay=800,time = 900, y = hat2.y - hatLift,transition=easing.inExpo, onComplete=
	function()
		carrot.x = wand.x+carrotPos[carrotCount]
		hat2open.y = hat2.y
		hat2.isVisible=false
		hat2open.isVisible=true
		if (previousX~=carrot.x)then
			if(carrot.x>previousX)then playSFX(M.bell) end
	tm:add( carrot, { delay=1000, time=500 ,xScale=1.5,yScale=1.5,transition=easing.outExpo, onComplete=function() 
	tm:add( carrot, { time=300 ,xScale=1,yScale=1,transition=easing.inExpo,onComplete=function()
		if(carrotCount==4)then 
		hurray() 
		openShow("close")
		playSFX(M.complete)
		else
		previousX = carrot.x
		wand:setEnabled( true ) 		
		end

					end})
					end} )

end
		if(carrotCount==4)then 
		else
		previousX = carrot.x
		wand:setEnabled( true ) 
		end
	end})

	end
end


		timer.performWithDelay(1500,function() openShow("open") end)
		playMusic( "play"  )
	

end




-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

		storyboard.removeAll()
	
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
		playMusic("fade")
		tm:cancelAll()
		
		if(confetti)then
		confetti:stop()
		confetti:destroy()
		confetti = nil 
		end
		if(closeTimer)then
		timer.cancel(closeTimer)
		closeTimer=nil
		end
	--	wand:removeEventListener('tap', start)
	--	hat1:removeEventListener('tap', revealBall)
	--	hat2:removeEventListener('tap', revealBall)
	--	hat3:removeEventListener('tap', revealBall)		
		storyboard.removeAll()
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
		playMusic("fade")
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
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