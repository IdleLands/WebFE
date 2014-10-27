angular.module 'IdleLands'
.controller 'Player', [
  '$scope', '$state', 'API', 'Player',
  ($scope, $state, API, Player) ->
    $scope.selectedIndex = 0
    $scope.selectTab = (tabIndex) -> $scope.selectedIndex = tabIndex

    $scope._player = Player

    $state.go 'login' if not $scope._player.getPlayer()
]