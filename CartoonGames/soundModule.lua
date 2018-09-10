-- define a local table to store all references to functions/variables
local M = {}

 
	local moveSnd = audio.loadSound('sounds/ribbit.mp3')
	local loseSnd = audio.loadSound('sounds/lose.mp3')
	local goalSnd = audio.loadSound('sounds/home.mp3')

	local bell = audio.loadSound("sounds/bell.mp3")	
	local squishMain = audio.loadSound("sounds/squishMain.mp3")		
	local shuffleIntro = audio.loadSound("sounds/shuffle.mp3")
	
	updateProgress( 0.2 )
	local up = audio.loadSound("sounds/up.mp3")
	local down = audio.loadSound("sounds/down.mp3")
	local circus = audio.loadStream("sounds/circus.mp3")
	local frogSong = audio.loadStream("sounds/frogMelody.mp3")
	local mystery	= audio.loadStream("sounds/mystery.mp3")
	local intro	= audio.loadStream("sounds/intro.mp3")
	updateProgress( 0.5 )
	local forewards = audio.loadSound("sounds/backwards.mp3")
	local backwards = audio.loadSound("sounds/forewards.mp3")
	local jump = audio.loadSound("sounds/jump1.mp3")
	local track = audio.loadStream("sounds/cartoon melodyV.mp3")
	local squish = audio.loadSound("sounds/squish.mp3")
	local complete = audio.loadSound("sounds/complete.mp3")
	local balloonPop = audio.loadSound("sounds/balloonPop.mp3");
	local match = audio.loadSound("sounds/boing.mp3");
	local fairy = audio.loadSound("sounds/fairy.mp3");
	local fairyWand = audio.loadSound("sounds/fairy-wand.mp3");
	updateProgress( 0.7 )
	local scales = {}
		for i = 1,8 do
			scales[i] = audio.loadSound("sounds/scales/" .. i .. ".mp3");
		end
	
	local instrument = { "harp" , "piano" , "flute" , "guitar"  }
	local note = {}

	for n=1,4 do
	note[instrument[n]]={}
	for i=1,8 do
	note[instrument[n]][i] = audio.loadSound("sounds/" .. instrument[n] .. "/" .. i .. ".mp3") 

	end
	end	
	updateProgress( 1 ) 
	-------------------
 
 
	M.moveSnd = moveSnd
	M.loseSnd = loseSnd
	M.goalSnd = goalSnd

	M.bell = bell
	M.squishMain = squishMain	
	M.shuffleIntro = shuffleIntro
	M.up = up
	M.down = down 
	
	M.circus = circus
	M.frogSong = frogSong
	M.mystery = mystery	
	M.intro	= intro	
	 
	
	M.forewards = forewards
	M.backwards = backwards
	M.jump = jump
	M.track = track
	M.squish = squish
	M.complete = complete
	M.balloonPop = balloonPop
	M.match = match
	M.fairy = fairy
	M.fairyWand = fairyWand
	
	M.scales = scales
	M.note = note


	
return M