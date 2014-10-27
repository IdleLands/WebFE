angular.module 'IdleLands'
.factory 'ReloginInterceptor', [
  'CredentialCache', '$injector',
  (CredentialCache, $injector) ->

    shouldRelog = (responseData) ->
      responseData.message is 'Token validation failed.'

    response: (response) ->
      ($injector.get 'API').auth.login CredentialCache.getCreds() if shouldRelog response.data
      response
]