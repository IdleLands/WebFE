angular.module 'IdleLands'
.factory 'Player', ->
  player = null

  getPlayer: -> player
  setPlayer: (newPlayer) -> player = newPlayer