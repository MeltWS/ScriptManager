local name = "Anywhere Farmer Dragons Den"
local author = "MeltWS"

local description = [[Money Farm DD]]

local pf           = require "ProshinePathfinder/Pathfinder/Maps_Pathfind" -- requesting table with methods
local ScriptBase   = require "Scripts/MSLBase"
local farmMap      = "Dragons Den"
local holdItem     = "Leftovers" -- support giving an item to the leader, if you don't want to give one, set to nil.
local farmMethod   = function() return moveToWater() end

local FarmMoneyDD  = ScriptBase:new()

function FarmMoneyDD:new()
    return ScriptBase.new(FarmMoneyDD, name, author, description)
end

-- failsafe function for battle, in the event where the last Pokemon is the active but API call attack() does not work.
-- This is due to his only move(s) with PP being not damaging type move(s).
local function useAnyMove()
    local pokemonId = getActivePokemonNumber()
    for i=1,4 do
        local moveName = getPokemonMoveName(pokemonId, i)
        if moveName and getRemainingPowerPoints(pokemonID, moveName) > 0 then
            log("Use any move")
            return useMove(moveName)
        elseif not moveName then
            log("useAnyMove : moveName nil")
        end
    end
    return false
end

local function hasUsableDamageMove(pokemonID)
    for i = 1, 4 do
        local moveName = getPokemonMoveName(pokemonID, i)
        if moveName ~= "False Swipe" and getPokemonMovePower(pokemonID, i) > 0 and getRemainingPowerPoints(pokemonID, moveName) > 0 then
            return true
        end
    end
    return false
end

local function swapLeaderWithUsablePokemon()
    for i = 1, getTeamSize() do
        if getPokemonHealth(i) > 0 and hasUsableDamageMove(i) then
            if not getPokemonHeldItem(1) then
                return assert(swapPokemonWithLeader(getPokemonName(i)), "Failed to swap Pokemon ".. i .."  with leader.")
            else return assert(takeItemFromPokemon(1), "Failed to retrieve item from leader")
            end
        end
    end
    return false
end

local function giveLeaderItem()
    local currentItem = getPokemonHeldItem(1)
    if not holdItem or currentItem == holdItem then
        return false
    elseif currentItem ~= nil then
        return assert(takeItemFromPokemon(1), "Failed to retrieve item from leader.")
    else return assert(giveItemToPokemon(holdItem, 1), "Failed to give item to Pokemon : " .. holdItem .. ", please make sure you have the item, otherwise set the holdItem value to nil.")
    end
end

function FarmMoneyDD:onPathAction()
    if getPokemonHealth(1) == 0 or not hasUsableDamageMove(1) then
        if not swapLeaderWithUsablePokemon() then
            return pf.UseNearestPokecenter()
        end
    elseif not giveLeaderItem() then
        if not pf.MoveTo(farmMap) then
            return farmMethod()
        end
    end
end

function FarmMoneyDD:onBattleAction()
    if getPokemonHealth(1) > 0 and getMapName() == farmMap then
        return attack() or run() or sendUsablePokemon() or sendAnyPokemon() or useAnyMove()
    else return run() or attack() or sendUsablePokemon() or sendAnyPokemon() or useAnyMove()
    end
end

return FarmMoneyDD