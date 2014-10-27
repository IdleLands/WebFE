angular.module 'IdleLands'
  .factory 'Authentication', [
    '$http', 'BaseURL',
    ($http, baseURL) ->

      url = "#{baseURL}/player/auth"

      login:          (data) -> $http.post  "#{url}/login", data
      logout:         (data) -> $http.post  "#{url}/logout", data
      register:       (data) -> $http.put   "#{url}/register", data
      changePassword: (data) -> $http.patch "#{url}/password", data
  ]