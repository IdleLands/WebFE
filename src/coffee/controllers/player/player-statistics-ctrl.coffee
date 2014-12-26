angular.module 'IdleLands'
.controller 'PlayerStatistics', [
  '$scope', 'CurrentPlayer'
  ($scope, Player) ->

    $scope.getAllStatisticsInFamily = (family) ->
      return if not $scope.player
      base = _.omit $scope.player.statistics, (value, key) ->
        key.indexOf(family) isnt 0

      $scope.statisticsKeys[family] = _.keys base

    $scope.initialize = ->
      _.each ['calculated', 'combat self', 'event', 'explore', 'player'], $scope.getAllStatisticsInFamily

    Player.observe().then null, null, -> $scope.initialize()

    $scope.initialize()

]