angular.module 'IdleLands'
.controller 'PlayerBattle', [
  '$scope', 'BattleColorMap', 'CurrentBattle'
  ($scope, BattleColorMap, CurrentBattle) ->

    $scope.filterMessage = (message) ->
      for search, replaceFunc of BattleColorMap
        regexp = new RegExp "(<#{search}>)([\\s\\S]*?)(<\\/#{search}>)", 'g'
        message = message.replace regexp, (match, p1, p2) ->
          replaceFunc p2

      message

    $scope.currentBattle = CurrentBattle.getBattle()

]