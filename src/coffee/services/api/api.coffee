angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action', 'Personality', 'Pushbullet', 'Strings', 'Gender', 'Inventory',
    (Authentication, Action, Personality, Pushbullet, Strings, Gender, Inventory) ->

      auth: Authentication
      action: Action
      personality: Personality
      pushbullet: Pushbullet
      strings: Strings
      gender: Gender
      inventory: Inventory
  ]