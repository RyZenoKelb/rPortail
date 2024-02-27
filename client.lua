-- Positions des portails
local portailPosition1 = vector3(446.28, -996.83, 30.69) -- Position de la plage de Vespucci
local portailPosition2 = vector3(-1165.79, -1587.31, 4.66) -- Position de la jetée de Del Perro

-- Crée les portails
local portailObjet1 = nil
local portailObjet2 = nil

Citizen.CreateThread(function()
    portailObjet1 = CreateObject(GetHashKey("prop_stargate_01"), portailPosition1.x, portailPosition1.y, portailPosition1.z, true, true, true)
    SetEntityVisible(portailObjet1, false, false)
    SetEntityCollision(portailObjet1, false, false)

    portailObjet2 = CreateObject(GetHashKey("prop_stargate_01"), portailPosition2.x, portailPosition2.y, portailPosition2.z, true, true, true)
    SetEntityVisible(portailObjet2, false, false)
    SetEntityCollision(portailObjet2, false, false)

    -- Ajoute des particules et des effets visuels
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
        Citizen.Wait(0)
    end

    UseParticleFxAssetNextCall("core")

    local portailFx1 = StartParticleFxLoopedOnEntity("ent_amb_stargate", portailObjet1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
    local portailFx2 = StartParticleFxLoopedOnEntity("ent_amb_stargate", portailObjet2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)

    SetParticleFxLoopedAlpha(portailFx1, 0.8)
    SetParticleFxLoopedAlpha(portailFx2, 0.8)
end)

-- Fonction pour téléporter le joueur
function TeleporterJoueur(position)
    SetEntityCoordsNoOffset(PlayerPedId(), position.x, position.y, position.z, false, false, false, true)
end

-- Vérifie si le joueur est près d'un portail
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId(), true)
        local distance1 = #(playerCoords - portailPosition1)
        local distance2 = #(playerCoords - portailPosition2)

        if distance1 < 1.5 then
            AfficherAide("Appuyez sur ~INPUT_CONTEXT~ pour entrer dans le portail")
            if IsControlJustPressed(0, 38) then
                TeleporterJoueur(portailPosition2)
            end
        elseif distance2 < 1.5 then
            AfficherAide("Appuyez sur ~INPUT_CONTEXT~ pour entrer dans le portail")
            if IsControlJustPressed(0, 38) then
                TeleporterJoueur(portailPosition1)
            end
        end
    end
end)

-- Fonction pour afficher un message d'aide
function AfficherAide(texte)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(texte)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
