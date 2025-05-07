Config = {}

Config.Framework = 'QBCore' -- 或者 'QBCore'

Config.RentalLocations = {
    {
        coords = vector4(-278.0, -917.0, 31.0, 70.0),
        pedModel = "a_m_y_business_03",
        label = "租车点 1",
        blipSprite = 226,
        blipColor = 3,
        blipScale = 0.7
    },
    {
        coords = vector4(216.0, -809.0, 30.0, 339.0),
        pedModel = "a_f_y_business_02",
        label = "租车点 2",
        blipSprite = 226,
        blipColor = 3,
        blipScale = 0.7
    }
}

Config.RentableVehicles = {
    {
        model = "adder",
        label = "Adder",
        price = 1000,
        image = "https://www.picgo.net/image/Banner.XZVnfu"
    },
    {
        model = "zentorno",
        label = "Zentorno",
        price = 800,
        image = "https://wiki.rage.mp/images/thumb/7/70/Zentorno.png/800px-Zentorno.png"
    }
}