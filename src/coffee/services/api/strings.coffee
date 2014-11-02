angular.module 'IdleLands'
.factory 'Strings', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/player/manage/string"

    set:    (data) -> $http.put  "#{url}/set", data
    remove: (data) -> $http.post "#{url}/remove", data
]