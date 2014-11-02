angular.module 'IdleLands'
.factory 'TurnTaker', [
  '$interval', 'API',
  ($interval, API) ->

    turnInterval = null

    beginTakingTurns: (player) ->
      if not player
        $interval.cancel turnInterval
        return

      return if turnInterval
      API.action.turn identifier: player.identifier

      turnInterval = $interval ->
        API.action.turn identifier: player.identifier
      , 10100
]