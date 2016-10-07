name = "Modulable Script Manager"
author = "Melt"
description = [[Manage loading different scripts.]]

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
    o = o or {}
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
    if not self.cycle then
        return false
    end
    self.currentHour = getTime()
    if self.lastCycleHour ~= self.currentHour then
        self.newDay = true
    elseif self.newDay then
        self.daysToLive = self.daysToLive - 1
        self.newDay = false
        if self.daysToLive == 0 then
            log("Manager ➜ time to cycle")
        end
    end
    return (self.daysToLive == 0)
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
        return onStart()
    end
    return true
end

function onStart()
    ScriptManager = ScriptManager:new()
    if ScriptManager.selected then
        log('Starting new random script ➜ ' .. ScriptManager.selected:message())
        return ScriptManager.selected:onStart()
    end
    return false
end

function onResume()
    if ScriptManager.selected then
        log("Resume Script ➜ " .. ScriptManager.selected:message())
        ScriptManager.selected:onResume()
    end
end

function onPause()
    if ScriptManager.selected then
        log("Pause Script ➜ " .. ScriptManager.selected:message())
        ScriptManager.selected:onPause()
    end
end

function onStop()
    if ScriptManager.selected then
        log("Stop Script ➜ " .. ScriptManager.selected:message())
        ScriptManager.selected:onStop()
        ScriptManager.selected = ScriptManager:next()
    end
end

function onPathAction()
    if ScriptManager:updateScript() then
        ScriptManager.selected:path()
    end
    if ScriptManager.isOver then
        fatal("No more script to do. Manager terminated.")
    end
end

function onBattleAction()
    if ScriptManager:updateScript() then
        ScriptManager.selected:battle()
    end
end

function onDialogMessage(message)
    if ScriptManager.selected then
        ScriptManager.selected:onDialogMessage(message)
    end
end

function onBattleMessage(message)
    if ScriptManager:updateScript() then
        ScriptManager.selected:onBattleMessage(message)
    end
end

function onSystemMessage(message)
    if ScriptManager.selected then
        ScriptManager.selected:onSystemMessage(message)
    end
end

function onLearningMove(moveName, pokemonIndex)
    if ScriptManager:updateScript() then
        ScriptManager.selected:onLearningMove(moveName, pokemonIndex)
    end
end
