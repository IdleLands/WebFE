angular.module 'IdleLands'
.factory 'Custom', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/custom"

    submit:  (data) -> $http.put    "#{url}/player/submit", data
    list:    (data) -> $http.post   "#{url}/mod/list", data
    approve: (data) -> $http.patch  "#{url}/mod/approve", data
    reject:  (data) -> $http.patch  "#{url}/mod/reject", data
    redeem:  (data) -> $http.post   "#{url}/redeem", data
]