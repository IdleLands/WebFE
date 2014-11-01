angular.module 'IdleLands'
.factory 'Personality', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/player/manage/personality"

    add:    (data) -> $http.put  "#{url}/add", data
    remove: (data) -> $http.post "#{url}/remove", data
]