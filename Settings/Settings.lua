-- Settings

-- Mode : The script manager handles two modes Random or Priority
-- Random means a script is taken randomly from the script doable.
-- Priority means the Manager tries to load the higher value first.
-- In Priority if two script have the same priority value, one will be picked randomly.
-- local Mode    = "Priority"
local Mode    = "Random"

-- Cycle : the time before the manager randomise another script.
-- time scale is in game days, one in game day is ~2h30, so setting the cycle to one will randomise a script every 2h30.
-- Set to nil if you don't care about cycling
local Cycle   = 1

local Scripts = {
    --  Here you put your scripts
    --  FileName   = Weight ( How many chances this script has to be loaded )
    -- CatchAbra = 1,
    FarmMoneyDD = 1,
    FarmMoneyVicHoenn = 1,
}

local Settings = {}

return {
    Mode = Mode,
    Cycle = Cycle,
    Scripts = Scripts
}