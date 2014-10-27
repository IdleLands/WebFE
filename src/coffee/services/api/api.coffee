angular.module 'IdleLands'
  .factory 'API', [
    'Authentication', 'Action'
    (Authentication, Action) ->

      auth: Authentication
      action: Action
  ]