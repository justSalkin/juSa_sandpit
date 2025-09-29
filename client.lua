local prompts = GetRandomIntInRange(0, 0xffffff)
local VorpCore = {}
local VORPInv = {}
local progressbar = exports.vorp_progressbar:initiate()
local Animations = exports.vorp_animations.initiate()

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

local towns = {}
local rewardType = nil
local JobCoordinates = { --change this to move the sandpit
    minX = -2752,
    minY = -2401,
    maxX = -2691,
    maxY = -2341
}

RegisterNetEvent("vorp:SelectedCharacter") --starts code after char selection
AddEventHandler("vorp:SelectedCharacter", function(charid)
load()
end)

function load() 
    if Config.useSandpit then
        if Config.blip ~= 0 then
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, -2718.85, -2372.36, 45.34)--change coords to move sandpit icon
            SetBlipSprite(blip, Config.blip, 1)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.Language.blipname)
        end
    end
end

Citizen.CreateThread(function() --create useshovle prompt
    Citizen.Wait(5000)
    local press = Config.Language.press
    digUp = PromptRegisterBegin()
    PromptSetControlAction(digUp, Config.keys["G"])
    press = CreateVarString(10, 'LITERAL_STRING', press)
    PromptSetText(digUp, press)
    PromptSetEnabled(digUp, 1)
    PromptSetVisible(digUp, 1)
    PromptSetStandardMode(digUp, 1)
    PromptSetHoldMode(digUp, 1)
    PromptSetGroup(digUp, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, digUp, true)
    PromptRegisterEnd(digUp)
end)

Citizen.CreateThread(function() 
    while true do
        if Config.useSandpit then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local sleep = true
            if playerCoords.x >= JobCoordinates.minX and playerCoords.x <= JobCoordinates.maxX and --check if player is in sand pit
                playerCoords.y >= JobCoordinates.minY and playerCoords.y <= JobCoordinates.maxY then
                sleep = false
                local label = CreateVarString(10, 'LITERAL_STRING', Config.Language.use)
                PromptSetActiveGroupThisFrame(prompts, label) --load useshovle prompt
                if Citizen.InvokeNative(0xC92AC953F0A982AE, digUp) then --if pressing the interaction-key
                    SetCurrentPedWeapon(playerped, GetHashKey("WEAPON_UNARMED"), true, 0, false, false)
                    Citizen.Wait(500)
                    TriggerServerEvent("juSa_sandpit:shovelcheck")
                end
            else
                --print("Player is outside the sandpit")
            end
            if sleep then
                Citizen.Wait(1500)
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent("juSa_sandpit:checkPos")
AddEventHandler("juSa_sandpit:checkPos", function()
    towns = RegisterTownRestriction()
    local restricted = isInRestrictedTown(towns, playerCoords)
    if restricted then
        TriggerEvent('vorp:NotifyLeft', Config.Language.NotifyTitle, Config.Language.inTown, "BLIPS", "blip_destroy", 4000, "COLOR_RED")
    else
        rewardType = "anywhere"
        useShovel(rewardType)
    end
end)

RegisterNetEvent("juSa_sandpit:shovelchecked")
AddEventHandler("juSa_sandpit:shovelchecked", function()
    rewardType = "sandpit"
    useShovel(rewardType)
end)

function useShovel(rewardType)
    Animations.startAnimation("gravedigging")
    local randomizer = math.random(Config.maxDifficulty, Config.minDifficulty)
    local testplayer = exports["syn_minigame"]:taskBar(randomizer, 7)
    if testplayer == 100 then
        TriggerServerEvent('juSa_sandpit:givereward', rewardType)
    else
        VorpCore.NotifyRightTip(Config.Language.missed,5000)
    end
    Animations.endAnimation("gravedigging")
end

function isInRestrictedTown(towns, playerCoords) --checks if player is in restricted arial
    player_coords = playerCoords or GetEntityCoords(PlayerPedId())
    local x, y, z = table.unpack(player_coords)
    local town_hash = GetTown(x, y, z)
    if town_hash == false then
        return false
    end
    if towns[town_hash] then
        return true
    end
    return false
end

function GetTown(x, y, z) --get map zone at this coords
    return Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 1)
end

function RegisterTownRestriction() --checking towns from config
    local towns = {}
    for i, town in pairs(Config.Towns) do
        if not town.allowed then
            local town_hash = GetHashKey(town.name)
            towns[town_hash] = town.name
        end
    end
    -- for hash, name in pairs(towns) do
    --     print("Town-Hash:", hash, "Townname:", name)
    -- end
    return towns
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming) --checks for animation with vorp_anim
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout>0) do
            timeout = timeout-1
            if timeout == 0 then
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag--[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end