angular.module 'IdleLands'
.factory 'CurrentPlayer', [
  '$q'
  ($q) ->
    player = null
    defer = $q.defer()

    observe: -> defer.promise
    getPlayer: -> player
    setPlayer: (newPlayer) ->
      player = newPlayer
      defer.notify player

]