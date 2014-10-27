angular.module 'IdleLands'
  .factory 'Token', ->
    token = null

    getToken: -> token
    setToken: (newToken) -> token = newToken