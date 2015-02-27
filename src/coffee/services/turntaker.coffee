angular.module 'IdleLands'
.factory 'TurnTaker', [
  '$interval', '$q', 'API',
  ($interval, $q, API) ->

    seconds = 0
    timeInterval = null
    defer = $q.defer()

    setSeconds = (newVal) ->
      seconds = newVal

      defer.notify seconds

    beginTakingTurns: (player) ->
      if not player
        $interval.cancel timeInterval
        return

      return if timeInterval
      API.action.turn identifier: player.identifier

      setSeconds 0

      timeInterval = $interval ->
        setSeconds seconds+1

        if seconds % 10 is 0
          setSeconds 0
          API.action.turn identifier: player.identifier

      , 1000

    getSeconds: -> seconds
    observe: -> defer.promise
]