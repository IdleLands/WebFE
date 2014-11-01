angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action', 'Personality', 'Pushbullet',
    (Authentication, Action, Personality, Pushbullet) ->

      auth: Authentication
      action: Action
      personality: Personality
      pushbullet: Pushbullet
  ]