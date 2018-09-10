display.setStatusBar( display.HiddenStatusBar )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
system.activate("multitouch")
local widget = require("widget")
local M = require("soundModule")

local singer = {}
local current = 1
local currentRest = 1
local isDrifting = 0
local beganTime = 0
local endedTime = beganTime+100
local button = {}
local buttons = { "Red" , "Orange" , "Yellow" , "Green" , "Blue" , "Indigo" , "Purple" , "Grey"}

local noteName = {"Do" , "Re" , "Mi" , "Fa" , "So" , "La" , "Ti" , "Do"}
local proceed = true

-- functions forewards ref	
	
local note = {}	
local playTune = {}
local cloudTap
local lyricChange = {}
--- timers ect
local tmr
local idx=1
local i = 1
---
local instrument = { "harp" , "piano" , "flute" , "guitar"  }
local select = instrument[2]
local lastT
local buttonHome


local function goBack()

	playSFX(M.backwards)
	storyboard.gotoScene( "start" , { time=1000, effect = "slideRight" })

end

function scene:createScene( event )
	local screenGroup = self.view
	

local background = display.newImage("images/rainbow.png")
background.x = midW
background.y = midH-40	
	screenGroup:insert(background)

local displayGp = display.newGroup()
screenGroup:insert(displayGp)
	

local function animateSing(rest)
-- rest 1,6 --sing 6,15
if(rest=="reset")then
	singer[current].isVisible=false
	singer[currentRest].isVisible=true
local newRest = math.random(1,9)
local timeDel = (math.random(1,8)*1000)	
	restTimer = timer.performWithDelay(timeDel, function() 
	singer[currentRest].isVisible=false
	singer[newRest].isVisible=true
	currentRest = newRest
	animateSing("reset")
	end)
else
if (restTimer)then timer.cancel(restTimer) end
		local beganTime = system.getTimer()
		if(beganTime>endedTime+500)then
		local randSing = math.random(10,18)
		local randRest = math.random(1,9)
			if(current)then
			singer[current].isVisible=false
			end
			if(currentRest)then
			singer[currentRest].isVisible=false
			end
		singer[randRest].isVisible=false
		singer[randSing].isVisible=true
		current = randSing
		currentRest = randRest
	local endedTime = system.getTimer()
	
		end								
	end											
end	
	
function cloudTap( event )
if(event.phase=="ended")then
	if(tmr)then
	timer.cancel(tmr)
	tmr=nil
	i = 1
	lyricChange('close')
	else
	lyricChange('open')
	playTune()
	end
end	
end

local cloud = widget.newButton{
	defaultFile= "images/cloud.png",
	overFile= "images/cloudOver.png",
	width = 284,
	height = 284,
	onEvent=cloudTap
}
cloud.x = midW
cloud.y = H-160
	screenGroup:insert(cloud)

for i = 1,9 do
singer[i] = display.newImageRect("images/singer/rest-" .. i .. ".jpg",128,128)
singer[i].x = cloud.x
singer[i].y = cloud.y
singer[i].isVisible = false
screenGroup:insert(singer[i])
end

for i = 1,9 do
local idx = i+9
singer[idx] = display.newImageRect("images/singer/sing-" .. i .. ".jpg",128,128)
singer[idx].x = cloud.x
singer[idx].y = cloud.y
singer[idx].isVisible = false
screenGroup:insert(singer[idx])
end


local function selectType(event)
local t = event.target
if(event.phase=="ended")then
select=t.name
transition.to(t,{time=400,xScale=1.5,yScale=1.5, transition=easing.outBounce})
t:setFillColor(139,234,116)

if(lastT)then
lastT:setFillColor(255,255,255)
transition.to(lastT,{time=400,xScale=1,yScale=1, transition=easing.outBounce})

end
 lastT=t
return true
end
end


local piano = display.newImageRect("images/piano.png",64,64)
piano.x = midW-320
piano.y = H-205
piano.name = "piano"
piano:addEventListener( "touch" , selectType )
lastT = piano
screenGroup:insert(piano)

local guitar = display.newImageRect("images/guitar.png",64,64)
guitar.x = midW-240
guitar.y = H-205
guitar.name = "guitar"
guitar:addEventListener( "touch" , selectType )
screenGroup:insert(guitar)

local flute = display.newImageRect("images/flute.png",64,64)
flute.x = midW+350
flute.y = H-205
flute.name = "flute"
flute:addEventListener( "touch" , selectType )
screenGroup:insert(flute)

local harp = display.newImageRect("images/harp1.png",64,64)
harp.x = midW+270
harp.y = H-205
harp.name = "harp"
harp:addEventListener( "touch" , selectType )
screenGroup:insert(harp)

local function makeDriftingText(txt, opts)

	local opts = opts
	local function killDTxt(obj)
		display.remove(obj)
		obj = nil
		isDrifting = isDrifting - 1
		if(isDrifting<1)then
		animateSing("reset")
		end
	end
	local dTime = opts.tm or 500
	local del = opts.del or 0
	local yVal = opts.yVal or 40
	local size = opts.size or 16
	local dTxt = display.newText(txt, 0, 0, "Helvetica", size)
	dTxt.x = opts.x
	dTxt.y = opts.y
	
	if opts.grp then
		opts.grp:insert(dTxt)
		dTxt:toBack()
	end
	
	transition.to(dTxt, { delay=del, time=dTime, y=opts.y-yVal, alpha=0, onComplete=killDTxt} )
	isDrifting = isDrifting + 1
	
end	


local function handleButtonEvent(event)

 local t = event.target
		if(event.name=="auto")then
		button[t.id].isVisible=false
			local buttonOver = display.newImage(button[t.id].tempFile)
			buttonOver.width = button[t.id].width
			buttonOver.height = button[t.id].height
			buttonOver.x = button[t.id].x
			buttonOver.y = button[t.id].y
			buttonOver.id = button[t.id]
				local function timerListener( object )
				return function()
				button[t.id].isVisible=true
				display.remove(object)
				object = nil
				end
				end

				timer.performWithDelay( 300, timerListener( buttonOver ) )

		end
  if ( "began" == event.phase ) then

		beganTime = system.getTimer()
		if(beganTime>endedTime+50)then

	local dur = event.duration or {}
	local options = {
	x = t.x,
	y = t.y-60,
	tm=2500,
	size = 46,
	yVal = 60,
	grp = displayGp
	}
	local audioHandle = M.note[select][t.id]
	playSFX(audioHandle)
	animateSing()
	makeDriftingText(t.name, options)
		end
	elseif( "ended" == event.phase or "cancelled"==event.phase)then
		endedTime = system.getTimer()	
  end
end

for i=1,8 do

button[i] = widget.newButton
{
	width=128,
	height =128,
    defaultFile = "images/mushroom" .. buttons[i] .. ".png",
    overFile = "images/mushroom" .. buttons[i] .. "Over.png",
    onEvent = handleButtonEvent
}
	button[i].x = i*110-20
	button[i].y = midH-50
	button[i].id = i
	button[i].name = noteName[i]
	button[i].tempFile = "images/mushroom" .. buttons[i] .. "Over.png"
	button[i]:addEventListener( "auto", handleButtonEvent )
	screenGroup:insert( button[i] )
end	


local lyricTxt = display.newText("Twinkle", 0, 0, "Comic Sans MS Bold", 90)
lyricTxt.x = midW
lyricTxt.y = 110
lyricTxt:setTextColor(45,38,31)
lyricTxt.xScale = 0.1 
lyricTxt.isVisible=false
displayGp:insert(lyricTxt)
	local song = {1,1,5,5,6,6,5,"P",4,4,3,3,2,2,1,"P",5,5,4,4,3,3,2,"P",5,5,4,4,3,3,2,"P",1,1,5,5,6,6,5,"P",4,4,3,3,2,2,1,"P"}
	--local song = {1,1,5}
	local lyrics = {"Twinkle" , "Twinkle" , "twinkle" , "twinkle" , "little" ,"little" , "star" ,"Pause","How I" , "How I" , "wonder" , "wonder" , "what" , "you" , "are" ,"Pause","Up above" , "Up above","Up above" , "the world", "the world" , "so high" , "so high" ,"Pause", "Like a" , "Like a" , "diamond" , "diamond" , "in the" , "in the", "sky" ,"Pause","How I" ,"How I" , "wonder" , "wonder" , "what" , "you" , "are" ,"Pause", "Twinkle" , "Twinkle" , "twinkle" , "twinkle" , "little" ,"little" , "star" }
	song.p =750
	song.timing=600

function lyricChange(obj)

if(obj=="open")then
	lyricTxt.text = lyrics[1]
	lyricTxt.isVisible=true
	transition.to(lyricTxt,{ time=400, xScale =1 })

end
if(obj=="close")then

	transition.to(lyricTxt,{ time=400, xScale =0.1,onComplete=function()
	lyricTxt.isVisible=false
															end })

	end

end	
	
local timing = song.timing	
	
local function onTimer( event )
    local playing = event.source.playing
	local playnote = song[i]
	if(playnote=="P")then
	timing=song.p
	playnote = nil
	else 
	lyricTxt.text = lyrics[i]
	playnote = song[i]
	timing=song.timing
	end
		if( playing.completed )then
		if(playnote)then
	local target =button[playnote]
	local event = { name="auto", phase="began" , target=target }
	target:dispatchEvent( event )		

		end
		if(i<#song)then
		i=i+idx
		playTune()
		else

		lyricChange('close')
		timer.cancel( tmr )
		tmr=nil
		i = 1
		end
		end
	
end


function playTune() 
	tmr = timer.performWithDelay( timing, onTimer )
	tmr.playing = { completed = true }
end


local function start()
animateSing("reset")
transition.to(piano,{ time=400, xScale=1.5, yScale=1.5, transition=easing.outBounce})
piano:setFillColor(139,234,116)

end
	
	buttonHome = widget.newButton
{
	id = "home",
    defaultFile = "images/mushroomLeft.png",
    overFile = "images/mushroomLeftOver.png",
	width=120,
	height=120,
    onRelease = goBack
}
	buttonHome.x = 50
	buttonHome.y = H-50
		screenGroup:insert( buttonHome )	
	
	
	
	
start()	
	
end


function scene:enterScene( event )
	local screenGroup = self.view
	playMusic("fade")
	storyboard.removeAll()
end


function scene:exitScene( event )
	local screenGroup = self.view

	storyboard.removeAll()
end


function scene:destroyScene( event )
	local screenGroup = self.view

end



-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene