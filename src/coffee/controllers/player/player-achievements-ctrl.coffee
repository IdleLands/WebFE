angular.module 'IdleLands'
.controller 'PlayerAchievements', [
  '$scope',
  ($scope) ->

    $scope.achievementTypeToIcon =
      'class': ['fa-child']
      'event': ['fa-info']
      'combat': ['fa-legal','fa-magic fa-rotate-90']
      'special': ['fa-gift']
      'personality': ['fa-group']
      'exploration': ['fa-compass']
      'progress': ['fa-signal']
]