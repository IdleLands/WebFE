angular.module 'IdleLands'
.factory 'TurnTaker', [
  '$interval', 'API',
  ($interval, API) ->

    seconds = 0
    turnInterval = null
    timeInterval = null

    beginTakingTurns: (player) ->
      if not player
        $interval.cancel turnInterval
        $interval.cancel timeInterval
        return

      return if turnInterval
      API.action.turn identifier: player.identifier

      seconds = 0

      timeInterval = $interval ->
        seconds++
      , 1000

      turnInterval = $interval ->
        seconds = 0

        API.action.turn identifier: player.identifier
      , 10100

    getSeconds: -> seconds
]