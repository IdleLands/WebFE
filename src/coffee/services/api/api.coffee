angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action', 'Battle', 'Personality', 'Pushbullet', 'Strings', 'Gender', 'Inventory', 'Shop',
    (Authentication, Action, Battle, Personality, Pushbullet, Strings, Gender, Inventory, Shop) ->

      auth: Authentication
      action: Action
      battle: Battle
      personality: Personality
      pushbullet: Pushbullet
      strings: Strings
      gender: Gender
      inventory: Inventory
      shop: Shop
  ]