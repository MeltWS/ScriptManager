local name = "Script Name"
local author = "Author"

local description = [[Everything.]]

local ScriptBase   = require "Lib/ScriptBase"

local TemplateScript  = ScriptBase:new()

-- This creates a script the manager can use.
function TemplateScript:new()
    return ScriptBase.new(TemplateScript, name, author, description)
end

-- can be omitted default : true
function TemplateScript:isDoable()
    -- is the quest doable ?
end

-- can be omitted default : not isDoable
function TemplateScript:isDone()
    -- is the quest over ?
end


function TemplateScript:onPathAction()
    -- do stuff
end

-- can be omitted : default run() or attack() or sendAnyPokemon()
function TemplateScript:onBattleAction()
    -- do stuff
end

-- any api hook you need preceeded by your script name.
-- omitt them if you do not use them.
function TemplateScript:onStop()
end

function TemplateScript:onPause()
end

-- if you do an action in onStart() you must return true
function TemplateScript:onStart()
end

function TemplateScript:onResume()
end

function TemplateScript:onDialogMessage(message)
end

function TemplateScript:onBattleMessage(message)
end

function TemplateScript:onSystemMessage(message)
end

function TemplateScript:onLearningMove(moveName, pokemonIndex)
end

-- return the script to the manager
return TemplateScript