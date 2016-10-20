local Table = require "Lib/Table"

local Game = {}

-- return treu and the coordinate of the npc found or false
function Game.isNpcInRectangle(xa, ya, xb, yb)
    for i = xa, xb do
        for j = ya, yb do
            if isNpcOnCell(i, j) then
                return true, { ["x"] = i, ["y"] = j}
            end
        end
    end
    return false
end

local avoidMove = {
    "false swipe",
    "dream eater"
}

function Game.hasUsableDamageMove(pokemonID)
    for i = 1, 4 do
        local moveName = getPokemonMoveName(pokemonID, i)
        if not Table.hasValue(avoidMove, moveName) and getPokemonMovePower(pokemonID, i) > 0 and getRemainingPowerPoints(pokemonID, moveName) > 0 then
            return true
        end
    end
    return false
end

return Game