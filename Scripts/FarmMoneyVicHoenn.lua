local name = "Anywhere Farmer Victory Road Hoenn"
local author = "MeltWS"

local description = [[Money Farm Victory Road Hoenn]]

local pf           = require "ProshinePathfinder/Pathfinder/Maps_Pathfind" -- requesting table with methods
local ScriptBase   = require "Lib/ScriptBase"
local farmMap      = "Victory Road Hoenn 1F"
local holdItem     = "Leftovers" -- support giving an item to the leader, if you don't want to give one, set to nil.
local farmMethod   = function() return moveToRectangle(4,37,22,41) end

local FarmMoneyVicHoenn  = ScriptBase:new()

function FarmMoneyVicHoenn:new()
    return ScriptBase.new(FarmMoneyVicHoenn, name, author, description)
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
    for i = 2, getTeamSize(), 1 do
        if getPokemonHealth(i) > 0 and hasUsableDamageMove(i) then
            if not getPokemonHeldItem(1) then
                return assert(swapPokemon(1, i), "Failed to swap Pokemon ".. i .."  with leader.")
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

function FarmMoneyVicHoenn:onPathAction()
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

local function useAnyBall()
    return useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball")
end

function FarmMoneyVicHoenn:onBattleAction()
    if isOpponentShiny() or not isAlreadyCaught() then
        return useAnyBall() or attack() or run() or sendUsablePokemon() or sendAnyPokemon()
    elseif getPokemonHealth(1) > 0 and getMapName() == farmMap then
        return attack() or run() or sendUsablePokemon() or sendAnyPokemon() or useAnyMove()
    else return run() or attack() or sendUsablePokemon() or sendAnyPokemon() or useAnyMove()
    end
end

return FarmMoneyVicHoenn