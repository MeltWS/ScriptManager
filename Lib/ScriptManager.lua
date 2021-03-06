--ScriptManager Class

local Settings          = require "Settings/Settings"
local Maybe             = require "Lib/Maybe"

local ScriptManager = {}

local Scripts = {}
for name, weight in pairs(Settings.Scripts) do -- load every Script
    local script = require("Scripts/" .. tostring(name))
    Scripts[script:new()] = weight
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
        o.lastSelected   = nil
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

function ScriptManager:getDoableRandom()
    local tDoable  = nil
    for script, weight in pairs(self.scripts) do
        if script:isDoable() then
            tDoable = tDoable or {}
            if self.lastSelected == script then
                weight = weight - 1
            end
            for i = 1, weight do
                table.insert(tDoable, script)
            end
        end
    end
    return tDoable
end

function ScriptManager:getDoablePriority()
    local tDoable  = nil
    local mPrio = 0
    for script, sPrio in pairs(self.scripts) do
        if script:isDoable() then
            tDoable = tDoable or {}
            if sPrio >= mPrio then
                if sPrio > mPrio then
                    tDoable = {}
                    mPrio = sPrio
                end
                table.insert(tDoable, script)
            end
        end
    end
    return tDoable
end

function ScriptManager:next()
    local td
    if self.mode == "Priority" then
        td = self:getDoablePriority()
    else
        td = self:getDoableRandom()
    end
    self.selected = Maybe.maybeMap(function(td) return td[math.random(#td)] end)(td) -- get random script doable
    self.lastSelected = self.selected
    return self.selected
end

function ScriptManager:isScriptOver()
    if not self.selected then
        return true
    elseif self.selected:isDone() then
        log("Manager ➜ " .. self.selected.name .. " is over")
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
        if self.selected and self.selected:onStop() then
            self.selected = nil
            return false
        end
        if not self:next() then
            self.isOver = true
            return false
        end
        log('Starting new ' .. self.mode .. ' script ➜ ' .. self.selected:message())
        return not self.selected:onStart() -- do not updateScript if onStart perform an action (true)
    end
    return true
end

return ScriptManager