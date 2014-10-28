angular.module 'IdleLands'
.controller 'Head', [
  '$scope', '$interval', 'TurnTaker', 'Player',
  ($scope, $interval, TurnTaker, Player) ->

    $scope.player = null
    $scope._player = Player

    $scope.$watch '_player.getPlayer()', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.player = newVal
      TurnTaker.beginTakingTurns $scope.player
]