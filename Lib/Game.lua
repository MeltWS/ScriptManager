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

return Game