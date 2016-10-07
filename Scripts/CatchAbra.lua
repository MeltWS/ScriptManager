--Configuration--
--DO THIS FIRST--

local autoEvolve = "off"

--Case Sensitive--
--Put the name of the map you want to train at between "". {Example: location = "Route 121"}
local location = "Route 5"

--the below is case-sensitive, add more moves by adding commas. ex : onlyCatchThesePokemon = {"Pokemon 1", "Pokemon 2", "Pokemon 3"}--
--Even if you set all other capture variables to false, we'll still try to catch these/this pokemon--
--Leave an empty "" here if you aren't using it--
local catchThesePokemon = {"Abra"}

--Hunting in Grass, Water or Cave Ground
local lookForGrass = true
local lookForWater = false
local caveGround = false --Advanced: If in a cave or other location where pokemon encounter anywhere, set up your rect coordinates.--
local minX = 14
local minY = 20
local maxX = 35
local maxY = 60

--What your opponents health percentage should be before starting to throw pokeballs.
local throwHealth = 1  --If using False Swipe as your attack move, set to 1.




--POKEMON CONFIGURATION--

--This is for if your sync pokemon can attack and use special move(eg: Sleep move). If you set this to true, Everything below must be false.
local useSyncBuff = false
local syncBuff = 1 --Must be in slot 1

--If using sync, set to true
local useSync = false
local sync = 1 --Must be in slot 1

--If using an attacker, set to true. If your attacker is also your sync, set sync to false and put your attacker in slot 1
local useAttack = false
local attacker = 2  --If your attacker is also your sync, set useSync to false and set to 1
local move = "False Swipe"  --Case Sensitive - Whatever move you want to use to deal damage. Between the ""

--If your using a special pokemon(A pokemon that can Parazlyze or put to Sleep, etc.) set true. Again, If your "Special" is also your sync, set sync to false and put your "special" in slot 1
local useSpecial = false
local special = 3  --If your "Special" is also your sync, set useSync to false and set to 1
local specialMove = "Hypnosis"  --Case Sensitive - Whatever Status Move you want to use. Between the ""
local status = "SLEEP"  --Set what your specialMove does (SLEEP, PARALYZE, etc..) between the ""




--POKEBALL Configuration--

local typeBall = "Pokeball"  --What type of ball you want to use(Pokeball, Great Ball, Ultra Ball) Between the ""
local buyBalls = true  --Pokeballs are from guy in celadon 50 for $9000. Ultra Balls are from guy near Kanto safari zone. Cant buy Great Balls yet.
local ballAmount = 50  --If pokeball count goes under this, buys balls.



--END OF CONFIGURATION--


local name = "Catch Abra"
local author = "Crazy3001"
local description = "Hunting at " .. location .. "."

--Start Of Script--

local ScriptBase   = require "Scripts/MSLBase"
local pf           = require "ProshinePathfinder/Pathfinder/Maps_Pathfind" -- requesting table with methods
local lib          = require "ProshinePathfinder/PathFinder/Lib/lib"

local CatchAbra  = ScriptBase:new()

function CatchAbra:new()
    return ScriptBase.new(CatchAbra, name, author, description)
end

local healCounter = 0
local shinyCounter = 0
local catchCounter = 0
local wildCounter = 0

function CatchAbra:onStart()
  log("Start botting.")
      if autoEvolve == "on" then
        if not isAutoEvolve() then
            enableAutoEvolve()
        end
    end

    if autoEvolve == "off" then
        if isAutoEvolve then
            disableAutoEvolve()
        end
    end
end

function CatchAbra:onPause()
  log("***********************************PAUSED - SESSION STATS***********************************")
  log("Shinies Caught: " .. shinyCounter)
  log("Pokemon Caught: " .. catchCounter)
  log("Pokemons encountered: " .. wildCounter)
  log("You have visited the PokeCenter ".. healCounter .." times.")
  log("*********************************************************************************************")
end

function CatchAbra:onDialogMessage(pokecenter)
   if stringContains(pokecenter, "There you go, take care of them!") then
        healCounter = healCounter + 1
        log("You have visited the PokeCenter ".. healCounter .." times.")
   end
end

function CatchAbra:onBattleMessage(wild)
  if stringContains(wild, "A Wild SHINY ") then
      shinyCounter = shinyCounter + 1
      wildCounter = wildCounter + 1
      log("Info | Shineys encountered: " .. shinyCounter)
      log("Info | Pokemon caught: " .. catchCounter)
      log("Info | Pokemon encountered: " .. wildCounter)
  elseif stringContains(wild, "Success! You caught ") then
      catchCounter = catchCounter + 1
      log("Info | Shineys encountered: " .. shinyCounter)
      log("Info | Pokemon caught: " .. catchCounter)
      log("Info | Pokemon encountered: " .. wildCounter)
  elseif stringContains(wild, "A Wild ") then
      wildCounter = wildCounter + 1
      log("Info | Shineys encountered: " .. shinyCounter)
      log("Info | Pokemon caught: " .. catchCounter)
      log("Info | Pokemon encountered: " .. wildCounter)
  end
end

local failedRun = false

function CatchAbra:onBattleMessage(message)
   if message == "You failed to run away!" then
       failedRun = true
   end
end

function ReturnHighestIndexUnderLevel()
  result = 0
  for i = 1, getTeamSize(), 1 do
      if getPokemonLevel(i) < levelPokesTo then
          result = i
      end
  end
  return result
end

function IsPokemonOnCaptureList()
  result = false
  if catchThesePokemon[1] ~= "" then
  for i = 1, TableLength(catchThesePokemon), 1 do
      if getOpponentName() == catchThesePokemon[i] then
          result = true
          break
      end
  end
  end
  return result
end

function TableLength(T)
local count = 0
for _ in pairs(T) do count = count + 1 end
return count
end

function CatchAbra:onLearningMove(moveName, pokemonIndex)
  forgetAnyMoveExcept(movesNotToForget)
end


function CatchAbra:onPathAction()
    if buyBalls == true and getItemQuantity(typeBall) < ballAmount then
        if typeBall == "Pokeball" then
            if getMapName() == "Celadon Mart 2" then
                if isNpcOnCell(8,5) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(8,5)
                return end
                if isNpcOnCell(8,6) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(8,6)
                return end
                if isNpcOnCell(8,7) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(8,7)
                return end
                if isNpcOnCell(8,8) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(8,8)
                return end
                if isNpcOnCell(9,5) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(9,5)
                return end
                if isNpcOnCell(10,5) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(10,5)
                return end
                if isNpcOnCell(11,5) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(11,5)
                return end
                if isNpcOnCell(11,6) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(11,6)
                return end
                if isNpcOnCell(11,7) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(11,7)
                return end
                if isNpcOnCell(11,8) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(11,8)
                return end
                if isNpcOnCell(10,8) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(10,8)
                return end
                if isNpcOnCell(9,8) then
                    pushDialogAnswer(1)
                    talkToNpcOnCell(9,8)
                return end
            else pf.MoveTo("Celadon Mart 2")
                lib.log1time("******************Buying More Pokeballs!******************")
                return
            end

        elseif typeBall == "Ultra Ball" then
            if getMapName() == "Safari Stop" then
                pushDialogAnswer(1)
                talkToNpcOnCell(2,14)
            else pf.MoveTo("Safari Stop")
                lib.log1time("******************Buying More Ultra Balls!******************")
                return
            end

        elseif typeBall == "Great Ball" then
            return fatal("You Need To Buy More Great Balls!")
        end
    end


    if useSync == true and useAttack == true and useSpecial == true then
        if getPokemonHealth(sync) >= 1 and isPokemonUsable(attacker) and getRemainingPowerPoints(attacker, move) >= 1 and isPokemonUsable(special) and getRemainingPowerPoints(special, specialMove) >= 1 then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPC()
        end

    elseif useSync == true and useAttack == true and useSpecial == false then
        if getPokemonHealth(sync) >= 1 and isPokemonUsable(attacker) and getRemainingPowerPoints(attacker, move) >= 1 then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPC()
        end

    elseif useSync == true and useAttack == false and useSpecial == true then
        if getPokemonHealth(sync) >= 1 and isPokemonUsable(special) and getRemainingPowerPoints(special, specialMove) >= 1 then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPC()
        end

    elseif useSync == true and useAttack == false and useSpecial == false then
        if getPokemonHealth(sync) >= 1 then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPC()
        end

    elseif useSync == false and useAttack == true and useSpecial == true then
        if isPokemonUsable(attacker) and getRemainingPowerPoints(attacker, move) >= 1 and isPokemonUsable(special) and getRemainingPowerPoints(special, specialMove) >= 1 then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPC()
        end

    elseif useSync == false and useAttack == false and useSpecial == true then
        if isPokemonUsable(special) and getRemainingPowerPoints(special, specialMove) >= 1 then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPC()
        end

    elseif useSync == false and useAttack == true and useSpecial == false then
        if isPokemonUsable(attacker) and getRemainingPowerPoints(attacker, move) >= 1 then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPC()
        end

    elseif useSync == false and useAttack == false and useSpecial == false then
        if isPokemonUsable(1) then
            if getMapName() == location then
                if lookForGrass then
                    moveToGrass()
                elseif lookForWater then
                    moveToWater()
                elseif caveGround then
                    moveToRectangle(minX, minY, maxX, maxY)
                end
            else pf.MoveTo(location)
            end
        else pf.UseNearestPokecenter()
        end
    end
end


function CatchAbra:onBattleAction()
    if isWildBattle() and (isOpponentShiny() or IsPokemonOnCaptureList()) then

        if useSync == true and useAttack == true and useSpecial == true then
            if getActivePokemonNumber() == sync then
                sendPokemon(attacker)
            return end
            if getActivePokemonNumber() == attacker and getOpponentHealthPercent() > throwHealth then
                if getRemainingPowerPoints(attacker, move) >= 1 then
                    if useMove(move) then return end
                end
            end
            if getActivePokemonNumber() == attacker and getOpponentHealthPercent() == throwHealth then
                if sendPokemon(special) then return end
            end
            if getActivePokemonNumber() == special and getOpponentHealthPercent() == throwHealth then
                if getRemainingPowerPoints(special, specialMove) >= 1 and getOpponentStatus() ~= status then
                    if useMove(specialMove) then return end
                end
            end
            if useItem(typeBall) then return end

        elseif useSync == true and useAttack == true and useSpecial == false then
            if getActivePokemonNumber() == sync then
                sendPokemon(attacker)
            return end
            if getActivePokemonNumber() == attacker and getOpponentHealthPercent() > throwHealth then
                if getRemainingPowerPoints(attacker, move) >= 1 then
                    if useMove(move) then return end
                end
            end
            if useItem(typeBall) then return end

        elseif useSync == true and useAttack == false and useSpecial == true then
            if getActivePokemonNumber() == sync then
                sendPokemon(special)
            return end
            if getActivePokemonNumber() == special then
                if getRemainingPowerPoints(special, specialMove) >= 1 and getOpponentStatus() ~= status then
                    if useMove(specialMove) then return end
                end
            end
            if useItem(typeBall) then return end

        elseif useSync == true and useAttack == false and useSpecial == false then
            if useItem(typeBall) then return end

        elseif useSync == false and useAttack == true and useSpecial == true then
            if getActivePokemonNumber() == attacker and getOpponentHealthPercent() > throwHealth then
                if getRemainingPowerPoints(attacker, move) >= 1 then
                    if useMove(move) then return end
                end
            end
            if getActivePokemonNumber() == attacker and getOpponentHealthPercent() == throwHealth then
                if sendPokemon(special) then return end
            end
            if getActivePokemonNumber() == special and getOpponentHealthPercent() == throwHealth then
                if getRemainingPowerPoints(special, specialMove) >= 1 and getOpponentStatus() ~= status then
                    if useMove(specialMove) then return end
                end
            end
            if useItem(typeBall) then return end

        elseif useSync == false and useAttack == false and useSpecial == true then
            if getActivePokemonNumber() == special and getOpponentHealthPercent() == throwHealth then
                if getRemainingPowerPoints(special, specialMove) >= 1 and getOpponentStatus() ~= status then
                    if useMove(specialMove) then return end
                end
            end
            if useItem(typeBall) then return end

        elseif useSync == false and useAttack == true and useSpecial == false then
            if getActivePokemonNumber() == attacker and getOpponentHealthPercent() > throwHealth then
                if getRemainingPowerPoints(attacker, move) >= 1 then
                    if useMove(move) then return end
                end
            end
            if useItem(typeBall) then return end

        elseif useSync == false and useAttack == false and useSpecial == false then
            if useItem(typeBall) then return end

        elseif useSyncBuff == true then
            if getOpponentHealthPercent() > throwHealth then
                if getRemainingPowerPoints(syncBuff, move) >= 1 then
                    if useMove(move) then return end
                end
            end
            if getOpponentHealthPercent() == throwHealth then
                if getRemainingPowerPoints(syncBuff, specialMove) >= 1 and getOpponentStatus() ~= status then
                    if useMove(specialMove) then return end
                end
            end
            if useItem(typeBall) then return end
        end

    else
        if failedRun then
            failedRun = false
            return sendUsablePokemon() or attack()
        else
            return run() or sendUsablePokemon()
        end
    end
    return run() or sendUsablePokemon()
end

return CatchAbra