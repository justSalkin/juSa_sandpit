Config = {}

Config.Shovel = "shovel" -- Item from your db you want to use as shovel

Config.useSandpit = true -- use sandpit
Config.blip = -1988105196 --set to 0 to show no sandpit blip
Config.digeverywhere = true -- allows to dig outside of the sandpit (respecting the town restrictions)

Config.minDifficulty = 3200 --value for shovle minigame
Config.maxDifficulty = 1500

------------------- Items -----------------------
-- translate "label" to your language
Config.Items = {
    {dbname = "sand", label = "sand", min_amount = 1, max_amount = 2},
    {dbname = "worm", label = "worm", min_amount = 1, max_amount = 1}
}
Config.SandpitItems = {
    {dbname = "sand", label = "sand", min_amount = 2, max_amount = 5},
    {dbname = "clay", label = "clay", min_amount = 2, max_amount = 3},
    {dbname = "diamond", label = "diamond", min_amount = 1, max_amount = 1}
    }
------------------- TRANSLATE HERE --------------
Config.Language = {
    use = "use a shovel to dig ",
    press = "press ",
    missed = "digging failed",
    reward = "You got  ",
    noShovel = "You don't have a shovel.",
    blipname = "sandpit",
    NotifyTitle = "digging", --left notify title
    inTown = "You are in a city, you are not allowed to dig here.", --in restricted towns
    outsideSandpit = "You won't find anything here. Try a sand pit.", --if useSandpit = false
    invfull = "Your inventory is full."
}
------------------- Interaction -----------------
Config.keys = {
    G = 0x760A9C6F, -- talk/interact
}
------------------- Don't touch -----------------
Config.Towns = {
    { name = "Annesburg",  allowed = true },
    { name = "Armadillo",  allowed = false },
    { name = "Blackwater", allowed = false },
    { name = "Lagras",     allowed = false },
    { name = "Rhodes",     allowed = true },
    { name = "StDenis",    allowed = false },
    { name = "Strawberry", allowed = false },
    { name = "Tumbleweed", allowed = false },
    { name = "Valentine",  allowed = true },
    { name = "Vanhorn",    allowed = false },
}