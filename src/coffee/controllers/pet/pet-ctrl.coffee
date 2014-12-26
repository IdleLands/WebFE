angular.module 'IdleLands'
.controller 'Pet', [
  '$scope', '$state', '$window', '$timeout', 'CurrentPet', 'CurrentPlayer', 'CredentialCache', 'TurnTaker'
  ($scope, $state, $window, $timeout, Pet, Player, CredentialCache, TurnTaker) ->

    if not Player.getPlayer()
      CredentialCache.tryLogin().then (->
          if not Player.getPlayer()
            $mdToast.show template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
            $state.go 'login'

          else
            TurnTaker.beginTakingTurns Player.getPlayer()
        ),
        (->
          $mdToast.show template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
          $state.go 'login'
        )

    $scope.xpPercent = 0
    $scope._ = $window._

    $window.scrollTo 0, document.body.scrollHeight

    $scope.calcXpPercent = ->
      $scope.xpPercent = ($scope.pet.xp.__current / $scope.pet.xp.maximum)*100

    initializing = yes

    # equipment page & overview page
    $scope.valueToColor = (value) ->
      return 'text-red' if value < 0
      return 'text-green' if value > 0

    $scope.$watch (->Pet.getPet()), (newVal, oldVal) ->
      return if newVal is oldVal

      initializing = yes

      $scope.pet = newVal
      $scope.calcXpPercent()

      $timeout ->
        initializing = no
      , 0

    $scope.selectedIndex = $state.current.data.selectedTab
]