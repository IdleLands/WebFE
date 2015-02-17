angular.module 'IdleLands'
  .factory 'EventStream', [
    '$http', 'BaseURL',
    ($http, baseURL) ->

      url = "#{baseURL}/game/events"

      small:          (data) -> $http.post  "#{url}/small", data
      medium:         (data) -> $http.post  "#{url}/medium", data
      large:          (data) -> $http.put   "#{url}/large", data
  ]