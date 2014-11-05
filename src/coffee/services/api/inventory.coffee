angular.module 'IdleLands'
.factory 'Inventory', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/player/manage/inventory"

    add:    (data) -> $http.put   "#{url}/add", data
    sell:   (data) -> $http.post  "#{url}/sell", data
    swap:   (data) -> $http.patch "#{url}/swap", data
]