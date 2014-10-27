angular.module 'IdleLands'
.factory 'Action', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/player/action"

    turn: (data) -> $http.post  "#{url}/turn", data
]