angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action', 'Battle', 'Personality', 'Pushbullet', 'Strings', 'Gender', 'Inventory', 'Shop', 'Priority'
    (Authentication, Action, Battle, Personality, Pushbullet, Strings, Gender, Inventory, Shop, Priority) ->

      auth: Authentication
      action: Action
      battle: Battle
      personality: Personality
      priority: Priority
      pushbullet: Pushbullet
      strings: Strings
      gender: Gender
      inventory: Inventory
      shop: Shop
  ]