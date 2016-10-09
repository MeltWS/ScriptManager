--ScriptManager Class

local Settings          = require "Settings/Settings"
local Maybe             = require "Lib/Maybe"

local ScriptManager = {}

local Scripts = {}
for name, weight in pairs(Settings.Scripts) do -- load every Script
    local script = require("Scripts/" .. tostring(name))
    for i = 1, weight do
        table.insert(Scripts, script:new())
    end
end

function ScriptManager:new(o)
    if not o then
        o = {}
        setmetatable(o, self)
        self.__index     = self
        o.scripts        = Scripts
        o.mode           = Settings.Mode
        o.daysToLive     = Settings.Cycle
        o.lastCycleHour  = getTime()
        o.currentHour    = getTime()
        o.newDay         = false
        o.idSelected     = nil
        o.selected       = nil
        o.isOver         = false
    end
    return o
end

function ScriptManager:message()
    if self.selected then
        return self.selected:message()
    end
    return nil
end

function ScriptManager:getDoable()
    local tDoable = nil
    for i, script in ipairs(self.scripts) do
        if script:isDoable() and self.idSelected ~= i then
            tDoable = tDoable or {}
            table.insert(tDoable, i)
        end
    end
    return tDoable
end

function ScriptManager:next()
    self.idSelected = Maybe.maybeMap(function(td) return td[math.random(#td)] end)(self:getDoable())
    self.selected   = self.scripts[self.idSelected]
    return self.selected
end

function ScriptManager:isScriptOver()
    if not self.selected or self.selected:isDone() then
        return true
    end
    return false
end

function ScriptManager:isCycleTime()
    if self.daysToLive then
        self.currentHour = getTime()
        if self.lastCycleHour ~= self.currentHour then
            self.newDay = true
        elseif self.newDay then
            self.daysToLive = self.daysToLive - 1
            self.newDay = false
            if self.daysToLive == 0 then
                log("Manager ➜ time to cycle")
                self.daysToLive = Settings.Cycle
                self.lastCycleHour = self.currentHour
                return true
            end
        end
    end
    return false
end

function ScriptManager:updateScript()
    if self:isScriptOver() or self:isCycleTime() then
        if self.selected then
            log(self.selected.name .. " is over")
        end
        if not self:next() then
            self.isOver = true
            return false
        end
        log('Starting new random script ➜ ' .. self.selected:message())
        return not self.selected:onStart() -- do not updateScript if onStart perform an action (true)
    end
    return true
end

return ScriptManager