angular.module 'IdleLands'
.factory 'ReloginInterceptor', [
  'CredentialCache', '$injector',
  (CredentialCache, $injector) ->

    shouldRelog = (responseData) ->
      responseData.message is 'Token validation failed.'

    response: (response) ->
      if shouldRelog response.data
        creds = CredentialCache.getCreds()
        ($injector.get 'API').auth.login creds if creds.identifier and creds.password
      response
]