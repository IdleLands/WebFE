angular.module 'IdleLands'
.controller 'PlayerAchievements', [
  '$scope', 'Player'
  ($scope, Player) ->

    $scope.achievementTypeToIcon =
      'class': ['fa-child']
      'event': ['fa-info']
      'combat': ['fa-legal','fa-magic fa-rotate-90']
      'special': ['fa-gift']
      'personality': ['fa-group']
      'exploration': ['fa-compass']
      'progress': ['fa-signal']

    $scope.$watch (-> Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)
      $scope.player = newVal

]