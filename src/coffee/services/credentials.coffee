angular.module 'IdleLands'
.factory 'CredentialCache', [
  'localStorageService', 'Token', '$injector', '$q',
  (localStorageService, Token, $injector, $q) ->
    credentials = {}

    cacheCreds = ->
      localStorageService.set 'identifier', credentials.identifier
      localStorageService.set 'name', credentials.name
      localStorageService.set 'password', credentials.password

    tryLogin: ->

      defer = $q.defer()

      identifier = localStorageService.get 'identifier'
      password = localStorageService.get 'password'

      if not identifier or not password
        defer.reject()
      else
        credentials =
          identifier: identifier
          password: password
          suppress: yes

        ($injector.get 'API').auth.login credentials
        .then ->
          Token.loadToken()
          defer.resolve()

      defer.promise

    getCreds: -> credentials
    setCreds: (newCreds) ->
      credentials = newCreds
      cacheCreds() if credentials.remember
  ]