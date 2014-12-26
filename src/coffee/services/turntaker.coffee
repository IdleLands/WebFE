angular.module 'IdleLands'
.factory 'TurnTaker', [
  '$interval', '$q', 'API',
  ($interval, $q, API) ->

    seconds = 0
    turnInterval = null
    timeInterval = null
    defer = $q.defer()

    setSeconds = (newVal) ->
      seconds = newVal
      defer.notify seconds

    beginTakingTurns: (player) ->
      if not player
        $interval.cancel turnInterval
        $interval.cancel timeInterval
        return

      return if turnInterval
      API.action.turn identifier: player.identifier

      setSeconds 0

      timeInterval = $interval ->
        setSeconds seconds+1
      , 1000

      turnInterval = $interval ->
        setSeconds 0

        API.action.turn identifier: player.identifier
      , 10100

    getSeconds: -> seconds
    observe: -> defer.promise
]