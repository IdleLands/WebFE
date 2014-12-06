angular.module 'IdleLands'
.factory 'Priority', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/player/manage/priority"

    add:    (data) -> $http.put  "#{url}/add", data
    remove: (data) -> $http.post "#{url}/remove", data
]