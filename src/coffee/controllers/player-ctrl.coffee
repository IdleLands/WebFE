angular.module 'IdleLands'
.controller 'Player', [
  '$scope', '$state', '$mdToast', 'API', 'Player', 'TurnTaker' ,'CredentialCache',
  ($scope, $state, $mdToast, API, Player, TurnTaker, CredentialCache) ->

    if not Player.getPlayer()
      CredentialCache.tryLogin().then (-> TurnTaker.beginTakingTurns Player.getPlayer()),
        (->
          $mdToast.show template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
          $state.go 'login'
        )

    $scope.selectedIndex = 0
    $scope.selectTab = (tabIndex) -> $scope.selectedIndex = tabIndex

    $scope.xpPercent = 0
    $scope.calcXpPercent = ->
      $scope.xpPercent = ($scope.player.xp.__current / $scope.player.xp.maximum)*100

    $scope.equipmentStatArray = [
      {name: 'str', fa: 'fa-legal fa-rotate-90'}
      {name: 'dex', fa: 'fa-crosshairs'}
      {name: 'agi', fa: 'fa-bicycle'}
      {name: 'con', fa: 'fa-heart'}
      {name: 'int', fa: 'fa-mortar-board'}
      {name: 'wis', fa: 'fa-book'}
      {name: 'fire', fa: 'fa-fire'}
      {name: 'water', fa: 'icon-water'}
      {name: 'thunder', fa: 'fa-bolt'}
      {name: 'earth', fa: 'fa-leaf'}
      {name: 'ice', fa: 'icon-snow'}
      {name: 'luck', fa: 'fa-moon-o'}
    ]

    $scope.valueToColor = (value) ->
      return 'text-red' if value < 0
      return 'text-green' if value > 0

    $scope._player = Player

    $scope.$watch '_player.getPlayer()', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.player = newVal

      $scope.calcXpPercent()
]