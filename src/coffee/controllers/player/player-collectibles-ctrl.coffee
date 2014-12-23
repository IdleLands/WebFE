angular.module 'IdleLands'
.controller 'PlayerCollectibles', [
  '$scope', 'CurrentPlayer'
  ($scope, Player) ->
    $scope.$watch (-> Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)
      $scope.player = newVal

]