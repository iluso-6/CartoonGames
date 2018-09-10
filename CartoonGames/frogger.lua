
display.setStatusBar(display.HiddenStatusBar)
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require("widget")
local CBE=require("CBEffects.Library")
local M = require("soundModule")
local tm = require("transitionManager")
tm = tm.new()

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)
--physics.setDrawMode('hybrid')

	musicTrack = M.frogSong

local completed = false
local frog
local frogX = midW
local frogY = H-60
local lives = {}
local cover = {}
local current=3
local goal
local trans
local introTimer

local lastY
local obstacles

-- Functions

local showGameView = {}
local gameListeners = {}
local addObstacle = {}
local update = {}
local onCollision 

local sheetData = { width=128, height=190, numFrames=8, sheetContentWidth=512, sheetContentHeight=512 }

local imageSheet = graphics.newImageSheet( "images/imageFrog/frogs-dizzy1.png", sheetData )

local sequenceData = {
	{ name="lie", start=8, count=1 },
	{ name="sit", start=1, count=1 },
	{ name="hop", start=1, count=7, time=650 },
}

local function sceneChanger(event)
playSFX(M.backwards, {onComplete=function() 
storyboard.gotoScene( "start" , {effect = "slideRight",time=1000} ) 
									end} )

end

local function introStar(current)
		completed = false

	if(current<=2 and current>=1)then
	cover[current+1]:removeSelf()
	cover[current+1]=nil
	end
	introTimer = timer.performWithDelay(2000, function()
	frog:setSequence("hop")
	frog:play()
	playSFX(M.moveSnd)
	tm:add(frog,{
	time=600,
	x=frogX,
	y=frogY,
	rotation=90,
	transition=easing.inOutExpo,
	onComplete=function()
	tm:add(frog,{
	time=260,
	rotation=360,
	onComplete=function()
	frog:setSequence("sit")
	frog:play()
	end})
	lives[current]:removeSelf()
	lives[current]=nil
	end })
	
	completed = true
	
	end )


end

local function movePlayer(e)

if(completed)then
	completed=false
	playSFX(M.moveSnd)
	local xPos
	local yPos
	if(e.target.id == 'up') then
	yPos = frog.y-70
	frog:setSequence("hop")
	frog:play()
	trans = transition.to(frog,{time=300,y=yPos,rotation=0, transition=easing.inOutExpo, onComplete=function()
	frog:setSequence("sit")
	frog:play()
	completed=true
	end })
	
	elseif(e.target.id == 'left') then
	xPos = frog.x - 70
	frog:setSequence("hop")
	frog:play()
	trans = transition.to(frog,{time=300,x=xPos,rotation=-90, transition=easing.inOutExpo, onComplete=function()
	frog:setSequence("sit")
	frog:play()
	completed=true
	end })		
	elseif(e.target.id == 'down') then
	yPos = frog.y + 70
	frog:setSequence("hop")
	frog:play()
	trans = transition.to(frog,{time=300,y=yPos,rotation=-180, transition=easing.inOutExpo, onComplete=function()
	frog:setSequence("sit")
	frog:play()
	completed=true
	end })			
	elseif(e.target.id == 'right') then
	xPos = frog.x + 70
	frog:setSequence("hop")
	frog:play()
	trans = transition.to(frog,{time=300,x=xPos,rotation=90, transition=easing.inOutExpo, onComplete=function()
	frog:setSequence("sit")
	frog:play()
	completed=true
	end })		

end

		end

end	


function scene:createScene( event )
	local screenGroup = self.view	

	
	
	local gameBg = display.newImage('images/imageFrog/road.png')
	gameBg.x = midW
	gameBg.y = midH+25
	screenGroup:insert( gameBg )
	
	obstacles = display.newGroup()
	addObstacle(184, 230, 'images/imageFrog/bus', true, 'r', 'car')
	addObstacle(190, 350, 'images/imageFrog/taxi', false, 'l', 'car')
	addObstacle(40, 350, 'images/imageFrog/car-blue', false, 'l', 'car')
	addObstacle(124, 120, 'images/imageFrog/car', false, 'l1', 'car')
	
	addObstacle(384, 230, 'images/imageFrog/car-red', true, 'r', 'car')
	addObstacle(370, 350, 'images/imageFrog/police', false, 'l', 'car')
	addObstacle(424, 120, 'images/imageFrog/truck', false, 'l1', 'car')
	
	addObstacle(784, 230, 'images/imageFrog/ambulance', true, 'r', 'car')
	addObstacle(800, 350, 'images/imageFrog/van', false, 'l', 'car')
	addObstacle(900, 120, 'images/imageFrog/firetruck', false, 'l1', 'car')
	
	screenGroup:insert( obstacles )
	

	local up = widget.newButton
{
    defaultFile = 'images/imageFrog/cone.png',
    overFile = 'images/imageFrog/coneOver.png',
	width=64,
	height=64,
	id = "up",
    onEvent = movePlayer
}
	up.x=W-120
	up.y=H-120
	screenGroup:insert( up )
	
	
	local left = widget.newButton
{
    defaultFile = 'images/imageFrog/cone.png',
    overFile = 'images/imageFrog/coneOver.png',
	width=64,
	height=64,
	id = "left",
    onEvent = movePlayer
}
	left.x=W-200
	left.y=H-80
	left.rotation=-90
	screenGroup:insert( left )
	
	
	local down = widget.newButton
{
    defaultFile = 'images/imageFrog/cone.png',
    overFile = 'images/imageFrog/coneOver.png',
	width=64,
	height=64,
	id = "down",
    onEvent = movePlayer
}
	down.x=W-120
	down.y=H-40
	down.rotation=180
	screenGroup:insert( down )
	
	
	local right = widget.newButton
{
    defaultFile = 'images/imageFrog/cone.png',
    overFile = 'images/imageFrog/coneOver.png',
	width=64,
	height=64,
	id = "right",
    onEvent = movePlayer
}
	right.x=W-40
	right.y=H-80
	right.rotation=90
	
	screenGroup:insert( right )
	
	for i=1,3 do
	cover[i] = display.newImageRect("images/imageFrog/star.png",112,112)
	cover[i].x = (120*i)-50
	cover[i].y = H-68
		screenGroup:insert( cover[i] )
	
	lives[i] = display.newImageRect("images/imageFrog/star-frog.png",112,112)
	lives[i].x = (120*i)-50
	lives[i].y = H-68
		screenGroup:insert( lives[i] )
	end
		buttonHome = widget.newButton
{
	id = "home",
    defaultFile = "images/mushroomLeft.png",
    overFile = "images/mushroomLeftOver.png",
	width=120,
	height=120,
    onRelease = sceneChanger
}

	buttonHome.x = 50
	buttonHome.y = 50
		screenGroup:insert( buttonHome )
		
	goal = display.newImageRect("images/imageFrog/lilypad-orange.png",128,128)
	goal.x = midW
	goal.y = 70
	goal:scale( 1,1 )
	goal.name = 'goal'	
		screenGroup:insert( goal )
		
	frog = display.newSprite( imageSheet, sequenceData )
	frog:scale(0.8,0.8)
	frog.x = lives[3].x
	frog.y = lives[3].y
	frog:setSequence("sit")
	frog:play()
	physics.addBody( frog, { isSensor = true, radius = 36 } )
		screenGroup:insert( frog )
	
	physics.addBody(goal, 'static',{radius = 40} )
	goal.isSensor = true
	obstacles:toFront()
	introStar(current)

function onCollision(e)
	local xPos
	local yPos
	if(e.other.name == 'car') then
	gameListeners('rmv')
	current = current-1
	if(trans)then
	transition.cancel( trans )
	end
	playSFX(M.loseSnd)
	frog:setSequence("lie")
	frog:play()
	if(current~=0)then
	xPos=lives[current].x
	yPos=lives[current].y

	tm:add(frog, { delay=1000, time=2000, x=xPos, y=yPos,rotation=360,onComplete=function()
	--frog:setSequence("sit")
	--frog:play()
	gameListeners('add')
	completed=true
	introStar(current)
	end})
	else
	xPos=cover[1].x
	yPos=cover[1].y
	tm:add(frog, { delay=1000, time=2000, x=xPos, y=yPos,rotation=360,onComplete=function()
	cover[1]:removeSelf()
	cover[1]=nil
	frog:removeSelf()
	frog=nil
		tm:add(buttonHome,{delay=1000, time=300, transition=easing.inOutExpo,xScale=1.4,yScale=1.4, onComplete=function()
		--playSFX( squish )
		tm:add(buttonHome,{ time=200, y=H-50,transition=easing.inOutExpo,xScale=1,yScale=1, onComplete=function() playSFX( M.squish ) end})  end})	
	
	end})
	end
	elseif(e.other.name == 'goal') then
	gameListeners('rmv')
	if(trans)then
	transition.cancel( trans )
 	frog:setSequence("sit")
	frog:play()
	end
	tm:add(frog,{time=700,x=goal.x,y=goal.y,rotation=900,xScale=1,yScale=1, transition=easing.inOutExpo, onComplete=function() tm:add(frog,{time=1000,xScale=0.8,yScale=0.8, transition=easing.inOutExpo }) end})
		playSFX(M.goalSnd)
		local i = #cover
		
		local function showStars()
		if(lives[i]~=nil)then
		lives[i]:removeSelf()
		lives[i]=nil
		end
		playSFX(M.fairy)
		cover[i]:toFront()
		tm:add(cover[i],{delay=600, time=1500,x=midW,y=midH,rotation=1080, transition=easing.inOutExpo,xScale=2.5,yScale=2.5, onComplete=function()
		tm:add(cover[i],{time=600,x=-10,y=100,rotation=-1080, transition=easing.inOutExpo,xScale=0.1,yScale=0.1, onComplete=function()  
		cover[i]:removeSelf()
		cover[i]=nil
		if(i~=1)then
		i = i-1 
		showStars()
		else
		tm:add(buttonHome,{delay=1000, time=300, transition=easing.inOutExpo,xScale=1.4,yScale=1.4, onComplete=function()
		--playSFX( squish )
		tm:add(buttonHome,{ time=400, y=H-50,transition=easing.outBounce,xScale=1,yScale=1, onComplete=function() playSFX( M.squish ) end})  end})
		end
		end})
		end})
		end

		showStars()
	end

end
	playMusic("play" )
	gameListeners('add')
end

function addObstacle(X, Y, graphic, inverted, dir, name)
	local c = display.newImage(graphic .. '.png', X, Y)
	c.dir = dir
	c.name = name
	
	if(inverted) then
		c.xScale = -1
	end
	
	-- Physics
	
	physics.addBody(c, 'static',{radius=50})
	c.isSensor = true
	
	obstacles:insert(c)
	
end	

function gameListeners(action)
	if(action == 'add') then
		Runtime:addEventListener('enterFrame', update)
		frog:addEventListener('collision', onCollision)
	else
		Runtime:removeEventListener('enterFrame', update)

		frog:removeEventListener('collision', onCollision)
	end
end


function update()

if(frog.x<0+(frog.width/3))then
frog.x=0+(frog.width/3)
elseif(frog.x>W-(frog.width/3))then
frog.x=W-(frog.width/3)
elseif(frog.y<0+(frog.height/4))then
frog.y=0+(frog.height/4)
elseif(frog.y>H)then
frog.y=H-(frog.height/4)
end	
	for i = 1, obstacles.numChildren do
		if(obstacles[i].dir == 'l1') then
			obstacles[i].x = obstacles[i].x - 2
		elseif(obstacles[i].dir == 'l') then
			obstacles[i].x = obstacles[i].x - 1
		else
			obstacles[i].x = obstacles[i].x + 1.5
		end
		
		-- Respawn obstacle when out of stage
		--Right
		if(obstacles[i].dir == 'r' and obstacles[i].x > display.contentWidth + (obstacles[i].width * 0.5)) then
			obstacles[i].x = -(obstacles[i].width * 0.5)
		end
		
		-- Respawn obstacle when out of stage
		--Left
		if(obstacles[i].dir == 'l' and obstacles[i].x < -(obstacles[i].width * 0.5)) then
			obstacles[i].x = display.contentWidth + (obstacles[i].width * 0.5)
		end
		if(obstacles[i].dir == 'l1' and obstacles[i].x < -(obstacles[i].width * 0.5)) then
		obstacles[i].x = display.contentWidth + (obstacles[i].width * 0.5)
		end
	end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

		storyboard.removeAll()
	
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )

		Runtime:removeEventListener('enterFrame', update)
		--frog:removeEventListener('collision', onCollision)
		
		playMusic("fade")
		tm:cancelAll()
		
			if(trans)then
			transition.cancel( trans )
			end
			
		if(introTimer)then
		timer.cancel(introTimer)
		introTimer=nil
		end
		
		storyboard.removeAll()

	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
		playMusic("fade")

	
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

return scene
