local name = "Thief Quest"
local author = "Melt"
local description = [[This script will clear the Thief quest, buy one thief TM, and teach it.]]

local pf          = require "ProshinePathfinder/Pathfinder/Maps_Pathfind" -- requesting table with methods
local ScriptBase  = require "Lib/ScriptBase"
local Game        = require "Scripts/Lib/Game"
local qStep       = 1 -- quest step
local stepDialogs = { -- Dialog checks for knowing when the quest advance.
    "Those things can be anywhere in this mart..",
    "Do you want to buy TM96 - Thief from me for 7500 each?"
}
local itemCount   = 0
local itemLocs    = {
    {"Celadon Mart 4", 6, 3},
    {"Celadon Mart 2", 13, 12},
    {"Celadon Mart 1", 17, 6},
}
local keepMoves = {"Cut", "Surf", "Dive", "Rock Smash"}
local stepAction  = {}

local TQ  = ScriptBase:new()

function TQ:new()
    return ScriptBase.new(TQ, name, author, description)
end

function TQ:isDoable()
    return not Game.hasPokemonWithMove("Thief")
end

local function findItem(itemIndex)
    local nextLoc = itemLocs[itemIndex]
    if nextLoc then
        local map = nextLoc[1]
        local npcX = nextLoc[2]
        local npcY = nextLoc[3]
        if pf.MoveTo(map) then
            return true
        elseif isNpcOnCell(npcX, npcY) then
            return talkToNpcOnCell(npcX, npcY)
        else
            itemCount = itemCount + 1
            return findItem(itemCount + 1)
        end
    end
    return false
end

stepAction[1] = function() -- talk to the thief NPC on top of Celadon Mart
    if not pf.MoveTo("Celadon Mart 6") then
        return talkToNpcOnCell(7, 7)
    end
end

stepAction[2] = function()
    if not findItem(itemCount + 1) and not pf.MoveTo("Celadon Mart 6") then
        talkToNpcOnCell(7, 7)
    end
end

stepAction[3] = function()
    Game.tryTeachMove("Thief", "TM96")
end

function TQ:onStart()
    if hasItem("TM96") then
        log("Already has item TM96 Thief, Skip to learning phase.")
        qStep = 3
    end
end

function TQ:onPathAction()
    stepAction[qStep]()
end

function TQ:onBattleAction()
    return run() or sendAnyPokemon() or attack()
end

function TQ:onDialogMessage(message)
    for i, check in ipairs(stepDialogs) do
        if message == check then
            qStep = i + 1
        end
    end
end

function TQ:onLearningMove()
    return forgetAnyMoveExcept(keepMoves)
end

return TQ
