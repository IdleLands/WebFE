angular.module 'IdleLands'
.factory 'CurrentMap', [
  'CurrentPlayer', '$q', '$http', 'BaseURL'
  (Player, $q, $http, baseURL) ->

    map = null
    mapName = null
    defer = $q.defer()

    setMap = (newMap) ->
      map = newMap
      defer.notify map

    Player.observe().then null, null, (player) ->

      return if player.map is mapName
      mapName = player.map

      $http.post "#{baseURL}/game/map", {map: player.map}
      .then (res) ->
        setMap res.data.map

    getMap: -> map
    observe: -> defer.promise
]