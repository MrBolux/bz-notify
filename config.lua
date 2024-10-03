config = {}
-- top-left, top-center, top-right, center-left, center, center-right, bottom-left, bottom-center, bottom-right
config.notification = {
  position = 'top-right',
  darkMode = true,
  sound = {
    playSound = true,
    volume = 0.8, -- 0.0 -> mute / 1.0 -> max
  }
}

-- Every parameter is optional
/**
  title = string
  description = string
  avatar = string
  icon = string https://heroicons.com/
  timeout = number
  color = string
  sound = string
*/

config.presetNotif = {
  lsCustom = {
    title = "Los santos custom",
    description= "The best garage of Los santos",
    avatar= 'lsCustom.png',
    timeout= 5000,
    color= "green",
  },
  ambulance = {
    title = "Pill box hospital",
    description= "Des medecins sont disponible",
    avatar= 'pillbox.png',
    timeout= 5000,
    color= "red",
    sound= 'emergency.mp3',
    actions = {
      label = 'Teleporte to nord',
      event = '', -- event name
      side = 'client', -- client or server
      parameters = {}
    }
  },
  tp = {
    title = "Teleporte to nord",
    timeout= 10000,
    color= "info",
    actions = {
      {
        label= "Yes",
        event= "hospital:client:Revive",
        side= "client",
        parameters = {'banking', 'Account Opened', 'green'},
      },
      {
        label= "No",
        event= "",
        side= "",
        parameters = {'banking', 'Account Opened', 'green'},
      },
    }
  },
  -- tp = {
  --   title = "Teleporte to nord",
  --   timeout= 10000,
  --   color= "info",
  --   actions = {
  --     {
  --       label = 'Oui',
  --       event = '', -- event name
  --       side = 'client', -- client or server
  --       parameters = {}
  --     },
  --     {
  --       label = 'Non',
  --       event = '', -- event name
  --       side = 'client', -- client or server
  --       parameters = {}
  --     }
  --   }
  -- },
}

-- TriggerClientEvent('okokRequests:RequestMenu', source, tonumber(args[1]), 10000, '<i class="fas fa-question-circle"></i>&nbsp;Job Offer', 'Tommy wants to hire you.', 'client', 'parameter1,parameter2,parameter3,parameter4,parameter5', 5)