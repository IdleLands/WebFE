angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action', 'Personality', 'Pushbullet', 'Strings', 'Gender',
    (Authentication, Action, Personality, Pushbullet, Strings, Gender) ->

      auth: Authentication
      action: Action
      personality: Personality
      pushbullet: Pushbullet
      strings: Strings
      gender: Gender
  ]