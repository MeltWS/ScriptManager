
local ScriptBase = {}

function ScriptBase:new(name, author, description)
    local o = {}
    setmetatable(o, self)
    self.__index   = self
    o.name         = name
    o.description  = description
    o.author       = author
    o.bikeUsable   = true
    return o
end

function ScriptBase:isDoable()
    return true
end

function ScriptBase:isDone()
    return not self:isDoable()
end

function ScriptBase:useBike()
    if hasItem("Bicycle") and self.bikeUsable then
        if isOutside() and not isMounted() and not isSurfing() then
            log("Using: Bicycle")
            return useItem("Bicycle")
        else
            return false
        end
    else
        self.bikeUsable = true
        return false
    end
end

function ScriptBase:message()
    return self.name .. ' by ' .. self.author .. ': ' .. self.description
end

function ScriptBase:onStop()
    return false
end

function ScriptBase:onPause()
    return false
end

function ScriptBase:onStart()
    return false
end

function ScriptBase:onResume()
    return false
end

function ScriptBase:path()
    if self.inBattle then
        self.inBattle = false
    end
    if self:useBike() then
        return true
    end
    return self:onPathAction()
end

function ScriptBase:battle()
    if not self.inBattle then
        self.inBattle = true
    end
    return self:onBattleAction()
end

function ScriptBase:onBattleAction()
    return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
end

function ScriptBase:onDialogMessage(message)
    return false
end

function ScriptBase:onBattleMessage(message)
    return false
end

function ScriptBase:systemMessage(message)
    if stringContains(message, "You can't do this while surfing!") then
        self.bikeUsable = false
    end
    return self:onSystemMessage()
end

function ScriptBase:onSystemMessage(message)
    return false
end

function ScriptBase:onLearningMove(moveName, pokemonIndex)
    return false
end

return ScriptBase
