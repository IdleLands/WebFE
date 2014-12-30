angular.module 'IdleLands'
.factory 'Custom', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/custom"

    submit:  (data) -> $http.put    "#{url}/player/submit", data
    approve: (data) -> $http.patch  "#{url}/mod/approve", data
    reject:  (data) -> $http.patch  "#{url}/mod/reject", data
]