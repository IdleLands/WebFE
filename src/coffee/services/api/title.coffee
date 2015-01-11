angular.module 'IdleLands'
.factory 'Title', [
  '$http', 'BaseURL',
  ($http, baseURL) ->
  
    url = "#{baseURL}/player/manage/title"
    
    set:    (data) -> $http.put  "#{url}/set", data
    remove: (data) -> $http.post "#{url}/remove", data
]