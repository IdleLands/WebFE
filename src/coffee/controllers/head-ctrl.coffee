angular.module 'IdleLands'
.controller 'Head', [
  '$scope', '$window', '$interval', 'Player', 'API',
  ($scope, $window, $interval, Player, API) ->

    $scope.player = null
    $scope._player = Player

    turnInterval = null

    $scope.beginTakingTurns = ->
      if not $scope.player
        $interval.cancel turnInterval
        return

      return if turnInterval

      turnInterval = $interval ->
        API.action.turn identifier: $scope.player.identifier
      , 10100

    $scope.$watch '_player.getPlayer()', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.player = newVal
      $scope.beginTakingTurns()
]