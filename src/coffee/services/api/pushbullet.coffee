angular.module 'IdleLands'
.factory 'Pushbullet', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/player/manage/pushbullet"

    set:    (data) -> $http.put  "#{url}/set", data
    remove: (data) -> $http.post "#{url}/remove", data
]