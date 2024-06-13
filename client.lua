local peds = {
    { model = "a_m_y_business_01", coords = vec3(919.03271484375, -36.167400360107, 77.937355041504), description = "Sklep Greenzone" },
    { model = "a_f_y_bevhills_01", coords = vec3(894.48693847656, -48.921241760254, 77.764137268066), description = "Garaż na Greeznone" },
    { model = "a_m_m_farmer_01", coords = vector3(20.0, 20.0, 0.0), description = "Farmer" },
}

local createdPeds = {}

function DrawText3D(coords, text, size, font)
    local camCoords = GetGameplayCamCoords()
    local distance = #(coords - camCoords)

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)

    SetDrawOrigin(coords.x, coords.y, coords.z + 1.2, 0)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    for _, pedData in ipairs(peds) do
        RequestModel(GetHashKey(pedData.model))

        while not HasModelLoaded(GetHashKey(pedData.model)) do
            Wait(1)
        end

        local ped = CreatePed(4, GetHashKey(pedData.model), pedData.coords.x, pedData.coords.y, pedData.coords.z, 0.0, false, true)
        
        -- Set ped properties
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        table.insert(createdPeds, { ped = ped, description = pedData.description })

        SetModelAsNoLongerNeeded(GetHashKey(pedData.model))
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for _, pedInfo in ipairs(createdPeds) do
            local pedCoords = GetEntityCoords(pedInfo.ped)
            DrawText3D(pedCoords, pedInfo.description, 1.0, 0)
        end
    end
end)