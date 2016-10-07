name = "Modulable Script Manager"
author = "Melt"
description = [[Manage loading different scripts.]]

local ScriptManager = require "Lib/ScriptManager"
local scriptManager = nil

function onStart()
    scriptManager = ScriptManager:new(scriptManager)
    scriptManager:updateScript()
end

function onResume()
    if scriptManager.selected then
        log("Resume Script ➜ " .. scriptManager.selected:message())
        scriptManager.selected:onResume()
    end
end

function onPause()
    if scriptManager.selected then
        log("Pause Script ➜ " .. scriptManager.selected:message())
        scriptManager.selected:onPause()
    end
end

function onStop()
    if scriptManager.selected then
        log("Stop Script ➜ " .. scriptManager.selected:message())
        scriptManager.selected:onStop()
        scriptManager.selected = nil
    end
end

function onPathAction()
    if scriptManager:updateScript() then
        scriptManager.selected:path()
    end
    if scriptManager.isOver then
        fatal("No more script to do. Manager terminated.")
    end
end

function onBattleAction()
    if scriptManager:updateScript() then
        scriptManager.selected:battle()
    end
end

function onDialogMessage(message)
    if scriptManager.selected then
        scriptManager.selected:onDialogMessage(message)
    end
end

function onBattleMessage(message)
    if scriptManager:updateScript() then
        scriptManager.selected:onBattleMessage(message)
    end
end

function onSystemMessage(message)
    if scriptManager.selected then
        scriptManager.selected:onSystemMessage(message)
    end
end

function onLearningMove(moveName, pokemonIndex)
    if scriptManager:updateScript() then
        scriptManager.selected:onLearningMove(moveName, pokemonIndex)
    end
end
