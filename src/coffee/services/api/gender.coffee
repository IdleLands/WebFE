angular.module 'IdleLands'
.factory 'Gender', [
  '$http', 'BaseURL',
  ($http, baseURL) ->
  
    url = "#{baseURL}/player/manage/gender"
    
    set:    (data) -> $http.put  "#{url}/set", data
    remove: (data) -> $http.post "#{url}/remove", data
]