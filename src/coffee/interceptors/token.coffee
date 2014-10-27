angular.module 'IdleLands'
  .factory 'TokenInterceptor', [
    'Token',
    (Token) ->
      request: (config) ->
        config.data = {} if not config.data
        config.data.token = Token.getToken()
        config

      response: (response) ->
        Token.setToken response.data.token if response.data.token
        response
  ]