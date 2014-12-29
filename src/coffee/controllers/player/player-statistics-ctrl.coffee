angular.module 'IdleLands'
.controller 'PlayerStatistics', [
  '$scope', 'CurrentPlayer'
  ($scope, Player) ->

    $scope.getAllStatisticsInFamily = (family) ->
      base = _.omit $scope.player.statistics, (value, key) ->
        key.indexOf(family) isnt 0

      $scope.statisticsKeys[family] = _.keys base

    $scope.initialize = ->
      return if not $scope.player
      _.each ['calculated', 'combat self', 'event', 'explore', 'player'], $scope.getAllStatisticsInFamily
      $scope.permanentStatisticsKeys = _.keys $scope.player.permanentAchievements
      $scope.showPermStats = not ($scope.permanentStatisticsKeys.length is 0)

    Player.observe().then null, null, -> $scope.initialize()

    $scope.initialize()

]