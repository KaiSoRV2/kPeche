Config = {

    Blips = {

        BlipsMaps = {
                Title = "Zone de Pêche",
                Type = 68, 
                Color = 3,
                Position = vector3(-1823.486, 5310.901, 5.57),
                Texte_Zone = "~INPUT_TALK~ pour commencer à ~g~Pêche",
        },
    },

    Shop = {

        {item = 'appats', name = "Appâts à poisson", price = 25, count = 1},
        {item = 'canne_a_peche', name = "Canne à pêche", price = 250},

    },

    Vente = {

        {name = "Thon", item = 'thon', price = 250},
        {name = "Truite", item = 'truite', price = 350},     
        {name = "Morue", item = 'morue', price = 450},
        {name = "Saumon", item = 'saumon', price = 2500},
 
    },

    Random_Poisson = {

        {item = "saumon", name = "Saumon", number = 1, id = 1},
        {item = "morue", name = "Morue", number = 1, id = 2},
        {item = "morue", name = "Morue", number = 1, id = 3},
        {item = "truite", name = "Truite", number = 1, id = 4},
        {item = "truite", name = "Truite", number = 1, id = 5},
        {item = "truite", name = "Truite", number = 1, id = 6},
        {item = "thon", name = "Thon", number = 1, id = 7},
        {item = "thon", name = "Thon", number = 1, id = 8},
        {item = "thon", name = "Thon", number = 1, id = 9},
        {item = "thon", name = "Thon", number = 1, id = 10},
    },

    Garage = {

        Zodiac_de_Peche = {name = 'dinghy4', label = 'Zodiac de Pêche', price = 5000, caution = 2500, spawnpos = vector3(-1602.393, 5260.64, 1.05), Heading_Bateau = 20.98},
        Bateau_de_Peche = {name = 'tug', label = 'Bateau de Pêche', price = 1000, caution = 500, spawnpos = vector3(-1601.771, 5264.98, 1.53), Heading_Bateau = 24.77,},

    },

    SpawnVehicle = {

        Bateau_Detruit = 2500,
        Retour_location = vector3(-1602.112, 5259.649, 0.75),
        TP_NPC = vector3(-1605.394, 5258.9, 2.10),
        TextMenuGarage = "Appuyez sur ~b~ [E] ~s~ pour ranger le bateau",

    },

    Ped = {
        {pedModel = 'u_m_y_baygor', heading = 302.91, position = vector3(-1592.671, 5203.073, 4.31 - 0.95), TalkPed = "Appuyez sur ~b~ [E] ~s~ pour parler au vendeur"},
    },

    Ped2 = {
        {pedModel = 'ig_djblamryans', heading = 27.47, position = vector3(-1600.76, 5204.46, 4.31 - 0.95), TalkPed = "Appuyez sur ~b~ [E] ~s~ pour parler à l'acheteur"},
    },

}

