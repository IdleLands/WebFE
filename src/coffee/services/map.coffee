angular.module 'IdleLands'
.factory 'CurrentMap', [
  '$rootScope', 'Player', '$http',
  ($root, Player, $http) ->

    map = null
    player = null

    $root.$watch (->Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal
      player = newVal

    $root.$watch (->player?.map), (newVal, oldVal) ->
      return if newVal is oldVal
      $http.post '//api.idle.land/game/map', {map: newVal}
      .then (res) ->
        map = res.data.map

    getMap: -> map
]