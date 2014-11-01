angular.module 'IdleLands'
.factory 'PlayerInterceptor', [
  'Player',
  (Player) ->
    request: (request) ->
      request.data = {} if not request.data
      player = Player.getPlayer()
      request.data.identifier = player.identifier if request.data?.token and player
      request

    response: (response) ->
      Player.setPlayer response.data.player if response.data.player
      response
]