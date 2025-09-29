VorpCore = {}
local VorpInv = exports.vorp_inventory:vorp_inventoryApi()

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv.RegisterUsableItem(Config.Shovel, function(data)
    if Config.digeverywhere then
        exports.vorp_inventory:closeInventory(data.source)
        TriggerClientEvent('juSa_sandpit:checkPos', data.source)
    else
        TriggerClientEvent("vorp:TipRight", data.source, Config.Language.outsideSandpit, 5000)
    end
end)

RegisterServerEvent("juSa_sandpit:shovelcheck")
AddEventHandler("juSa_sandpit:shovelcheck", function()
	local _source = source
	local shovel = VorpInv.getItemCount(_source, Config.Shovel)
	if shovel > 0 then
		TriggerClientEvent("juSa_sandpit:shovelchecked", _source)
	else
		TriggerClientEvent("vorp:TipRight", _source, Config.Language.noShovel, 5000)
	end
end)

RegisterServerEvent("juSa_sandpit:givereward")
AddEventHandler("juSa_sandpit:givereward", function(rewardType)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local FinalLoot = LootToGive(_source, rewardType)
    if rewardType == "anywhere" then
        for k,v in pairs(Config.Items) do
            if v.dbname == FinalLoot then
                local amount = math.random(v.min_amount, v.max_amount)
                VorpInv.addItem(_source, FinalLoot, amount)
                LootsToGive = {}
                TriggerClientEvent("vorp:TipRight", _source, "" ..Config.Language.reward.. " " ..amount.. "x " ..v.label.. "." , 4000)
            end
        end
    elseif rewardType == "sandpit" then
        for k,v in pairs(Config.SandpitItems) do
            if v.dbname == FinalLoot then
                local amount = math.random(v.min_amount, v.max_amount)
                VorpInv.addItem(_source, FinalLoot, amount)
                LootsToGive = {}
                TriggerClientEvent("vorp:TipRight", _source, "" ..Config.Language.reward.. " " ..amount.. "x " ..v.label.. "." , 4000)
            end
        end
    end
end)

function LootToGive(_source, rewardType)
	local LootsToGive = {}
    if rewardType == "anywhere" then
        for k,v in pairs(Config.Items) do
            table.insert(LootsToGive,v.dbname)
        end
    elseif rewardType == "sandpit" then
        for k,v in pairs(Config.SandpitItems) do
            table.insert(LootsToGive,v.dbname)
        end
    else
        print("wrong rewardType")
    end 

	if LootsToGive[1] ~= nil then
		local value = math.random(1,#LootsToGive)
		local picked = LootsToGive[value]
		return picked
	end
end