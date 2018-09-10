local Module = {};
 
local moduleName = "splash.lua: ";
local loaderFunction;                   -- function called to load main screen
local splashScreen;                             -- the splash screen
local frameCount = 0;                   -- keep track of frames
local usingSplash = false;              -- true when splash screen is used
 
local loadSplashScreen = function(onlyText) 
        local splashObject;
		local splashTxt
        
        splashScreen = display.newGroup();
        
        if (onlyText) then
                splashObject = display.newText("Loading...", 0, 0, native.systemFontBold, 20);
        else
                splashObject = display.newImageRect("images/back.png", W, H );
				splashTxt = display.newImageRect("images/loadingTxt.png",250,75)
				splashTxt.x = midW
				splashTxt.y = midH
        end
        
        splashObject.x = midW
        splashObject.y = midH
        
        splashScreen:insert(splashObject);   
		splashScreen:insert(splashTxt);   
end
 
local enterFrameListener = function()
        frameCount = frameCount + 1;
        
        if (frameCount == 3) then -- skip some frames to allow splash to load
                if (not loaderFunction) then
                        print(moduleName.."WARNING: loader function not set");
                else
                        loaderFunction();
                end
        end;
end
 
Module.startSplash = function(onlyText)
        loadSplashScreen(onlyText);
        Runtime:addEventListener("enterFrame", enterFrameListener);
        usingSplash = true;
end
 
Module.stopSplash = function()
        if (usingSplash) then
                Runtime:removeEventListener("enterFrame", enterFrameListener);
                splashScreen:removeSelf();
                splashScreen = nil;
                usingSplash = false;
        end
end
 
Module.setLoader = function(loader)
        if (type(loader) ~= "function") then
                print(moduleName.."ERROR: loader must be a function");
        else
                loaderFunction = loader;
        end
end
 
return Module;

--[[
The 3 main functions are:
splash.setLoader(func) --> pass the function to load your main screen
splash.startSplash([true | false]) --> show the splash screen (optionally specifying if only a text screen should be used)
splash.stopSplash() --> remove splash screen and free memory

To use the module, just require it in your main.lua, and call setLoader and startSplash:
(if using Option 1 above then Default.png should exist in the root folder of your app)


-- main.lua
 
local directives = require("directives");
local splash = require("splash");
local game = require("game");
 
 
if (directives.TARGET == "Android") then
        splash.setLoader(game.startGame);
        splash.startSplash(); -- by default a graphical screen will be displayed
        --splash.startSplash(true); -- use this if you only want a simple "Loading..." text (faster display)
else
        game.startGame();
end


--]]