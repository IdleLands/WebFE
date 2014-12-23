angular.module 'IdleLands'
.factory 'PlayerInterceptor', [
  'CurrentPlayer',
  (CurrentPlayer) ->
    request: (request) ->
      request.data = {} if not request.data
      player = CurrentPlayer.getPlayer()
      request.data.identifier = player.identifier if request.data?.token and player
      request

    response: (response) ->
      CurrentPlayer.setPlayer response.data.player if response.data.player
      response
]