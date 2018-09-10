
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local CBE=require("CBEffects.Library")
local widget = require("widget")
local movieclip = require("movieclipMod")
local M = require("soundModule")
local timers = require("timerManager")
local tm = require("transitionManager")
tm = tm.new()

local physics = require("physics");
physics.setDrawMode("normal")
physics.start()
physics.setGravity(0, -0.98)

	----forewards here----

local contentFiles = {"images/animals/Bear.png" , "images/animals/Turkey.png" , "images/animals/Monkey.png" , "images/animals/Koala.png" , "images/animals/Lion.png" , "images/animals/Owl.png" , "images/animals/Panda.png" , "images/animals/Penguin.png" , "images/animals/Tiger.png" , "images/animals/Wolf.png" } 	
	
	musicTrack = M.track
	
local head
local body
local foot

local sceneCancelled=false
local rand = math.random
local buttonRed
local buttonGreen
local switchListener 
local yLoc = midH
local lastLoc = midH
local currentLayer = body
local trackPlay
local startGame = {}
local ceiling
local fairyStar
local balloonsNum = 12
local balloons = 0
local balloonCreater
local balloontime
local balloonColor = {{255,82,69,100},{254,255,40},{81,255,252},{20,255,255},{255,30,234,100},{81,255,252}}

local hasMatchedTop = false
local hasMatchedMid = false
local hasMatchedBottom = false
local saveStar=false
local randomSpin = {}
local startBubbles = {}
local cleanBubbles
local idx = 1

local function shuffle()

	playMusic("play")
	switchListener("on")
	local pick = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
	local aN = rand( 1,#pick )
	local a = pick[aN]
	table.remove(pick,aN)
	local bN = rand( 1,#pick )
	local b = pick[bN]
	table.remove(pick,bN)
	local cN = rand( 1,#pick )
	local c = pick[cN]
	table.remove(pick,cN)

	head:stopAtFrame( a ) 
	body:stopAtFrame( b )
	foot:stopAtFrame( c )

	buttonRed:setEnabled( true ) 
	buttonGreen:setEnabled( true )
	saveStar=false
	idx = 1;
	balloons = 0;
	pick=nil
end

local function removeBalloons(obj)

	if(obj and obj~=nil and sceneCancelled==false)then
	playSFX(M.balloonPop);
	obj:removeSelf();
	obj=nil;
	
	balloons = balloons - 1;
		if(balloons==0)then 
		fairyStar:stop()
		fairyStar:destroy()
		fairyStar = nil
		startGame()
		end
	end
	
end	

local function showSign() 

	fairyStar=CBE.NewVent{
		preset="default",
		posRadius=220, -- Appear randomly inside of a radius of 220 px
		lifeSpan=500,
		fadeInTime=200,
		startAlpha=0,
		perEmit=4,
		emitDelay=100,
		color={{255, 255, 0}}, -- Yellow particles
		build=function()
			local size=math.random(30, 80)
			return display.newImageRect("CBEffects/sparkle_particle.png", size, size)
			
		end,
		physics={
			velocity=0 -- Not moving
		}
	}
	fairyStar:start()
		playMusic("fade")
		playSFX(M.complete)
		randomSpin()
	balloonCreater = timer.performWithDelay(800, startBubbles, balloonsNum);
	
end


function scene:createScene( event )					-------------------------
	local screenGroup = self.view

local background = display.newImageRect("images/landscape-full.png",W,H)
background.x = midW
background.y = midH

	screenGroup:insert( background )

	ceiling = display.newRect (0, 0, display.contentWidth, 1);
	ceiling.isVisible=false
	physics.addBody (ceiling, "static",   { bounce = 0.1 } );
	screenGroup:insert( ceiling )

head = movieclip.newAnim( contentFiles )
body = movieclip.newAnim( contentFiles )
foot = movieclip.newAnim( contentFiles )	
	
local top = display.newGroup()
local mid = display.newGroup()
local lower = display.newGroup()
	
top:insert( head )
mid:insert( body )
lower:insert( foot ) 



local head_mask = graphics.newMask( "images/head-maskN.png" )
local mid_mask = graphics.newMask( "images/mid-maskN1.png" )

if(contentFiles==people2)then
	head_mask = graphics.newMask( "images/head-maskN1.png" )
	mid_mask = graphics.newMask( "images/mid-maskN1.png" )
  else
	mid_mask = graphics.newMask( "images/mid-maskN.png" )
end

local foot_mask = graphics.newMask( "images/foot-maskN.png" )


top:setMask( head_mask )
top.x = midW
top.y = midH

mid:setMask( mid_mask )
mid.x = midW
mid.y = midH

lower:setMask( foot_mask )
lower.x = midW
lower.y = midH

	screenGroup:insert( top )
	screenGroup:insert( mid ) 
	screenGroup:insert( lower )
	
local function frameCheck()

	local function headSwell(obj)
		tm:add(obj,{ time=150, xScale=1.1, yScale=1.1, onComplete=function()
		tm:add(obj,{ time=150, xScale=1, yScale=1})
		end})
	end

	if(head:currentFrame()==body:currentFrame() and body:currentFrame()==foot:currentFrame())then 
	switchListener("off")
	buttonRed:setEnabled( false ) 
	buttonGreen:setEnabled( false ) 
	showSign()
	elseif( head:currentFrame()==body:currentFrame() and hasMatchedTop==false )then
	headSwell(head)
	headSwell(body)
	playSFX( M.match )
	
	hasMatchedTop=true
	elseif( foot:currentFrame()==body:currentFrame() and hasMatchedBottom==false )then
	headSwell(foot)
	headSwell(body)
	playSFX( M.match ) 
	
	hasMatchedBottom=true
	elseif( foot:currentFrame()==head:currentFrame() and hasMatchedMid==false )then
	headSwell(foot)
	headSwell(head)
	playSFX( M.match )
	
	hasMatchedMid=true
	end
end

function randomSpin()
local num = rand(1,3)


	lower:setMask( nil )
	top.isVisible=false
	mid.isVisible=false
	
		local spin = function() tm:add(lower, { delay=2000, time=1700, rotation=720, transition=easing.inOutExpo, onComplete=function()
		lower.rotation=0
		top.isVisible=true
		mid.isVisible=true
		lower:setMask( foot_mask )
											end})
		end
					  
		local spinLeft = function() tm:add(lower, { delay=2000, time=900, xScale=0.5, yScale=0.5, rotation=-360, transition=easing.inOutExpo, onComplete=function()
		tm:add(lower, { time=1000, xScale=1, yScale=1, rotation=360, transition=easing.inOutExpo, onComplete=function()
		lower.rotation=0
		top.isVisible=true
		mid.isVisible=true
		lower:setMask( foot_mask )
																	end})
					end})
					
		end

		local growUp = function() tm:add(lower, { delay=2000, time=500, xScale=1.5, yScale=1.5,transition=easing.inOutExpo, onComplete=function()
		tm:add(lower, { delay=1000,time=300, xScale=0.5, yScale=0.5, transition=easing.inExpo, onComplete=function()
		tm:add(lower, { time=300, xScale=1, yScale=1, transition=easing.inOutExpo, onComplete=function()
		top.isVisible=true
		mid.isVisible=true
		lower:setMask( foot_mask )
															end})
			end})
					end})
		end
		
		if(num==1)then
		growUp()
		elseif(num==2)then
		spinLeft()
		else
		spin()
		end
end

function startBubbles()
local myBalloon = {}
	myBalloon[#myBalloon + 1] = display.newImageRect("images/bubble-128.png", 128,128);
	local ball = myBalloon[#myBalloon]
	screenGroup:insert( ball )
	if(rand(1,2)==1)then
	ball:setFillColor( unpack( balloonColor[rand(1,6)] ) )
	end
	ball:setReferencePoint(display.CenterReferencePoint);
	ball.x = rand(100, W-100);
	ball.y = (H+50);
	ball.touched=false
	physics.addBody(ball, "dynamic", {density=0.1, friction=0.0, bounce=0.9, radius= rand(30, 60)});
	
	
	function ball:touch(event)
		if ( event.phase == "began" ) then
			display.getCurrentStage():setFocus( event.target )
		elseif (event.phase == "ended") then

			self.touched=true			
			removeBalloons(self); 
				if(idx<9)then
				playSFX(M.scales[idx])
	
					if(idx==8 and saveStar==false)then

	local star = display.newImageRect("images/star.png",256,256)
	star.x = -200
	star.y = 150
	star:scale(4, 4)
	screenGroup:insert( star )
	tm:add( star, { time=400, xScale=1,x=midW,y=midH+80, yScale=1, rotation=360, transition=easing.outBounce, onComplete = function() 
	tm:add( star, { delay=2200, time=500,x=-200,y=150, rotation=-600, onComplete = 
		function()
		star:removeSelf();
		star=nil;
		
		end} )
	end} )

					playSFX(M.fairy)
					saveStar=true
				end
					display.getCurrentStage():setFocus( nil )
				end
				idx = idx+1
		end
	 return true
	end
		
	balloons = balloons + 1;
	balloontime = timer.performWithDelay(8000, function() 
	
		if(ball.touched==false)then 
			removeBalloons(ball) 
			end 
		end);
		
	ball:addEventListener("touch", ball);
end
		
local function handleButtonEvent(event)

		local options =
		{
			effect = "slideRight",
			time = 1000,
			params = { }
		}
		
 local t = event.target
	if ( "ended" == event.phase ) then
		if(currentLayer==head or currentLayer==body)then
		hasMatchedTop=false
		end
		if(currentLayer==body or currentLayer==foot)then
		hasMatchedBottom=false
		end
		if(currentLayer==head or currentLayer==foot)then
		hasMatchedMid=false
		end
		if(t.id=="red")then
				currentLayer:previousFrame()
				playSFX( M.backwards )
				frameCheck()
		 elseif(t.id=="green")then
				currentLayer:nextFrame()
				playSFX( M.forewards )
				frameCheck()
		 elseif(t.id=="home")then
			sceneCancelled=true
			playSFX(M.backwards, {onComplete=function() storyboard.gotoScene( "start" , options )  end} )
	
		 end
	end
end	
	
local function screenTapEvent(event)
		
	 if ( "ended" == event.phase ) then
	 switchListener("off")
		 if(event.y>0 and event.y<230)then
		 currentLayer = head
		 yLoc = 130
		 elseif(event.y>230 and event.y<400)then
		 currentLayer = body
		 yLoc = midH
		 elseif(event.y>400 and event.y<H)then
		 currentLayer = foot
		 yLoc = midH+180
		 end
	 if(yLoc==lastLoc)then
			 playSFX( M.squish )
		 
			 local popRed = tm:add( buttonRed, { delay=rand(200), time=100 ,xScale=1.2,yScale=1.2,transition=easing.outExpo, onComplete=function() 
			 tm:add( buttonRed, { time=80 ,xScale=1,yScale=1,transition=easing.inExpo })
			 end} )
			 local popGreen = tm:add( buttonGreen, { delay=rand(200), time=100 ,xScale=1.2,yScale=1.2,transition=easing.outExpo, onComplete=function() 
			 tm:add( buttonGreen, { time=80 ,xScale=1,yScale=1,transition=easing.inExpo, onComplete=function()  switchListener("on")  end })
			 end} )
		
		 else
			 
			 playSFX( M.jump )
			 local transRed = tm:add( buttonRed ,{time=200+rand(400),delay=rand(200), y = yLoc, transition=easing.outBounce,onComplete=function()  switchListener("on")  end} )
			 local transGreen = tm:add( buttonGreen ,{time=200+rand(400),delay=rand(200), y = yLoc, transition=easing.outBounce} )

		 end
		lastLoc = yLoc
	 end

end

	local screenTap = display.newRect(0,0,W,H)
	screenTap.isVisible = false
	screenTap.isHitTestable = true
	screenGroup:insert( screenTap )


	buttonRed = widget.newButton
{
    defaultFile = "images/mushroomOrange.png",
    overFile = "images/mushroomOrangeOver.png",
	id = "red",
    onEvent = handleButtonEvent
}
	buttonRed.x = midW-380
	buttonRed.y = midH
		screenGroup:insert( buttonRed )
----------------------------------------
	
	buttonGreen = widget.newButton
{
    defaultFile = "images/mushroomYellow.png",
    overFile = "images/mushroomYellowOver.png",
	id = "green",
    onEvent = handleButtonEvent
}
	buttonGreen.x =  midW+380
	buttonGreen.y = midH
		screenGroup:insert( buttonGreen )
-----------------------------------------	
	
	buttonHome = widget.newButton
{
	id = "home",
    defaultFile = "images/mushroomLeft.png",
    overFile = "images/mushroomLeftOver.png",
	width=120,
	height=120,
    onEvent = handleButtonEvent
}
	buttonHome.x = 50
	buttonHome.y = H-50
		screenGroup:insert( buttonHome )
------------------------------------------


function switchListener(pass)
	if(sceneCancelled==false)then
		if(pass=="on")then
		screenTap:addEventListener( "touch", screenTapEvent )
		else
		screenTap:removeEventListener( "touch", screenTapEvent )
		end
	end	
end


function startGame()
if(currentLayer and currentLayer==body)then 
	else
		playSFX(M.jump)
		yLoc = midH
		local resetRed = tm:add( buttonRed ,{time=200+rand(400),delay=rand(200), y = yLoc, transition=easing.outBounce} )
		local resetGreen = tm:add( buttonGreen ,{time=200+rand(400),delay=rand(200), y = yLoc, transition=easing.outBounce} )
		currentLayer = body
		lastLoc = yLoc

end
		head:setSpeed(.17)
		body:setSpeed(.17)
		foot:setSpeed(.17)
		body:play()
		head:play()
		foot:play()
		 playSFX(M.shuffleIntro, {onComplete=shuffle} )
		buttonRed:setEnabled( false ) 
		buttonGreen:setEnabled( false )
end

	startGame()

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

	-- remove previous scene's view	
	--local prior_scene = storyboard.getPrevious()
	--storyboard.purgeScene( prior_scene )
	storyboard.removeAll()
end


-- Called when scene is about to move offscreen:
function scene:exitScene()
	if sfxIsPlaying then
		audio.stop()
	end
	
	switchListener("off")
	tm:cancelAll()
	if(balloonCreater)then  timer.cancel( balloonCreater )  end
	if(balloontime)then  timer.cancel( balloontime )  end


	
		if(fairyStar)then
		fairyStar:stop()
		fairyStar:destroy()
		fairyStar = nil
		end
		

	storyboard.removeAll()
end
	


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
		if sfxIsPlaying then
		audio.stop()
		end
--[[
	for i=1, #myBalloon do
	
		if(myBalloon[i]~=nil and myBalloon[i].touched==false)then
		print(myBalloon[i])
		myBalloon[i]:removeSelf()
		myBalloon[i]=nil
		print(myBalloon[i])
		end
	
	end
--]]
	

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