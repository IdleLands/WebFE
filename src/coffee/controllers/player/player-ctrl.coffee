angular.module 'IdleLands'
.controller 'Player', [
  '$scope', '$state', '$window', '$timeout', '$mdToast', 'API', 'CurrentPlayer', 'TurnTaker' ,'CredentialCache', 'OptionsCache'
  ($scope, $state, $window, $timeout, $mdToast, API, Player, TurnTaker, CredentialCache, OptionsCache) ->

    if not Player.getPlayer()
      CredentialCache.tryLogin().then (->
        if not Player.getPlayer()
          $mdToast.show template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
          $state.go 'login'

        else
          TurnTaker.beginTakingTurns Player.getPlayer()
        ),
        (->
          #$mdToast.show template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
          $state.go 'login'
        )

    OptionsCache.load ['scrollback']
    $scope.options = OptionsCache.getOpts()
    $scope.xpPercent = 0
    $scope.statisticsKeys = {}

    $scope._ = $window._

    $window.scrollTo 0, document.body.scrollHeight

    $scope.calcXpPercent = ->
      $scope.xpPercent = ($scope.player?.xp.__current / $scope.player?.xp.maximum)*100

    $scope.logout = ->
      Player.setPlayer null
      CredentialCache.doLogout()
      API.auth.logout()
      $state.go 'login'

    # equipment page & overview page
    $scope.valueToColor = (value) ->
      return 'text-red' if value < 0
      return 'text-green' if value > 0

    # scrollback
    $scope.handleScrollback = ->
      classFunc = if $scope.options.scrollback is 'true' then 'removeClass' else 'addClass'
      scrollback = (angular.element '.scrollback-toast')[classFunc] 'hidden'

    $timeout $scope.handleScrollback, 3000

    $scope.turnTimeValue = 0

    TurnTaker.observe().then null, null, (newVal) ->
      $scope.turnTimeValue = newVal * 10

    $scope.initialize = ->
      $scope.player = Player.getPlayer()
      $window.scrollback.nick = $scope.player?.name
      $scope.calcXpPercent()

    Player.observe().then null, null, ->
      $scope.initialize()

    $scope.initialize()

    # watches
    $scope.$watch 'options', (newVal, oldVal) ->
      return if newVal is oldVal
      OptionsCache.saveAll()
      $scope.handleScrollback()
    , yes

    $scope.selectedIndex = $state.current.data.selectedTab
]