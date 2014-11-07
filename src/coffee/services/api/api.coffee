angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action', 'Battle', 'Personality', 'Pushbullet', 'Strings', 'Gender', 'Inventory',
    (Authentication, Action, Battle, Personality, Pushbullet, Strings, Gender, Inventory) ->

      auth: Authentication
      action: Action
      battle: Battle
      personality: Personality
      pushbullet: Pushbullet
      strings: Strings
      gender: Gender
      inventory: Inventory
  ]