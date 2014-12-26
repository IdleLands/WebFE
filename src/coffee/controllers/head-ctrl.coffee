angular.module 'IdleLands'
.controller 'Head', [
  '$scope', '$interval', 'TurnTaker', 'CurrentPlayer',
  ($scope, $interval, TurnTaker, Player) ->

    $scope.player = null

    Player.observe().then null, null, (newVal) ->
      $scope.player = newVal
      TurnTaker.beginTakingTurns $scope.player
]