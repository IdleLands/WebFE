angular.module 'IdleLands'
.factory 'CurrentPlayer', ->
  player = null

  getPlayer: -> player
  setPlayer: (newPlayer) -> player = newPlayer