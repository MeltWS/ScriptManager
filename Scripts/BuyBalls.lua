local name = "Buy Pokeballs"
local author = "Melt"

local description = [[Buy Pokeballs]]

local pf           = require "ProshinePathfinder/Pathfinder/Maps_Pathfind" -- requesting table with methods
local ScriptBase   = require "Lib/ScriptBase"
local Game         = require "Lib/Game"

local BuyBalls  = ScriptBase:new()

-- config
local Quantity = 100 -- Qtty goes by 50
local BuyIfLessThan = 100
-- end of config

local toBuy = 0
local rocketDialog = "How about you. Want 50 pokeballs for $9000? I don't ever do refunds, be warned."

function BuyBalls:new()
    return ScriptBase.new(BuyBalls, name, author, description)
end

-- can be omitted default : true
function BuyBalls:isDoable()
    return getItemQuantity("Pokeball") < BuyIfLessThan and getMoney() > 9000 * Quantity / 50
end

function BuyBalls:isDone()
    return toBuy <= 0
end

function BuyBalls:onStart()
    toBuy = Quantity
    return
end

function BuyBalls:onPathAction()
    if not pf.MoveTo("Celadon Mart 2") then
        local check, loc = Game.isNpcInRectangle(7, 5, 13, 10)
        if check then
            return talkToNpcOnCell(loc.x, loc.y)
        end
    end
end

function BuyBalls:onDialogMessage(message)
    if not (getMoney() > 9000) then
        toBuy = 0
        return false
    end
    if message == rocketDialog then
        pushDialogAnswer("Yes")
        toBuy = toBuy - 50
    end
end

local function useAnyBall()
    return useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball")
end

function BuyBalls:onBattle()
    if isOpponentShiny() or not isAlreadyCaught() then
        return useAnyBall() or run() or attack() or sendUsablePokemon() or sendAnyPokemon()
    end
    return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
end

return BuyBalls