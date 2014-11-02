angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action', 'Personality', 'Pushbullet', 'Strings',
    (Authentication, Action, Personality, Pushbullet, Strings) ->

      auth: Authentication
      action: Action
      personality: Personality
      pushbullet: Pushbullet
      strings: Strings
  ]