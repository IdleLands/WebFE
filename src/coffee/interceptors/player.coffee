angular.module 'IdleLands'
.factory 'PlayerInterceptor', [
  'Player',
  (Player) ->
    response: (response) ->
      Player.setPlayer response.data.player if response.data.player
      response
]