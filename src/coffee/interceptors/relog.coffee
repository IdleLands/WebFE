angular.module 'IdleLands'
.factory 'ReloginInterceptor', [
  'CredentialCache', '$injector',
  (CredentialCache, $injector) ->

    shouldRelog = (response) ->
      not response.data or response.data.message is 'Token validation failed.'

    response: (response) ->
      if shouldRelog response
        creds = CredentialCache.getCreds()
        ($injector.get 'API').auth.login creds if creds.identifier and creds.password
      response
]