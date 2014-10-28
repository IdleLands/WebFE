angular.module 'IdleLands'
  .factory 'Token', [
    'localStorageService',
    (localStorageService) ->
      token = null

      loadToken: ->
        return if token
        token = localStorageService.get 'token'

      getToken: -> token
      setToken: (newToken) ->
        token = newToken
        localStorageService.set 'token', token
  ]