angular.module 'IdleLands'
.factory 'Battle', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/game/battle"

    get: (data) -> $http.post  "#{url}", data
]