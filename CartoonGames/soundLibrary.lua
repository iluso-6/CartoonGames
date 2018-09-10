-- define a local table to store all references to functions/variables
local M = {}
 
-- functions are now local:
local testFunction1 = function()
    print( "Test 1" )
end
-- assign a reference to the above local function
M.testFunction1 = testFunction1
 
local testFunction2 = function()
    print( "Test 2" )
end
M.testFunction2 = testFunction2
 
local testFunction3 = function()
    print( "Test 3" )
end
M.testFunction3 = testFunction3
 
-- Finally, return the table to be used locally elsewhere
return M