angular.module 'IdleLands'
.factory 'CurrentMap', [
  '$rootScope', 'Player', '$http', 'BaseURL'
  ($root, Player, $http, baseURL) ->

    map = null
    player = null

    $root.$watch (->Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal
      player = newVal

    $root.$watch (->player?.map), (newVal, oldVal) ->
      return if newVal is oldVal
      $http.post "#{baseURL}/game/map", {map: newVal}
      .then (res) ->
        map = res.data.map

    getMap: -> map
]