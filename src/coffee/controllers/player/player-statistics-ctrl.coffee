angular.module 'IdleLands'
.controller 'PlayerStatistics', [
  '$scope', 'CurrentPlayer', '$timeout'
  ($scope, Player, $timeout) ->

    $scope.getAllStatisticsInFamily = (family) ->
      base = _.omit $scope.player.statistics, (value, key) ->
        key.indexOf(family) isnt 0

      $scope.statisticsKeys[family] = _.keys base

    $scope.initialize = ->
      return unless $scope.player
      $timeout ->
        _.each ['calculated', 'combat self', 'event', 'explore', 'player'], $scope.getAllStatisticsInFamily
        $scope.permanentStatisticsKeys = _.keys $scope.player.permanentAchievements
        $scope.showPermStats = $scope.permanentStatisticsKeys.length isnt 0
      , 0

    Player.observe().then null, null, -> $scope.initialize()

    $scope.initialize()

]