angular.module 'IdleLands'
.factory 'ReloginInterceptor', [
  'CredentialCache', '$injector',
  (CredentialCache, $injector) ->

    shouldRelog = (response) ->
      not response.data or response.data.message in ['Token validation failed.', "You aren't logged in!"]

    response: (response) ->
      if shouldRelog response
        creds = CredentialCache.getCreds()
        ($injector.get 'API').auth.login creds if creds.identifier and creds.password
      response
]