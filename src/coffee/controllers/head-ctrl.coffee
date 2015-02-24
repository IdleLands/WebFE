angular.module 'IdleLands'
.controller 'Head', [
  '$scope', '$interval', 'TurnTaker', 'CurrentPlayer', 'CurrentTheme'
  ($scope, $interval, TurnTaker, Player, CurrentTheme) ->

    $scope.player = null
    $scope.theme = CurrentTheme.getTheme()

    Player.observe().then null, null, (newVal) ->
      $scope.player = newVal
      TurnTaker.beginTakingTurns $scope.player

    CurrentTheme.observe().then null, null, (newVal) ->
      $scope.theme = newVal
]