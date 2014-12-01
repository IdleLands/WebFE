angular.module 'IdleLands'
.factory 'Shop', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/player/manage/shop"

    buy:    (data) -> $http.put   "#{url}/buy", data
]