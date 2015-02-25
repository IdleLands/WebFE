angular.module 'IdleLands'
.controller 'Pet', [
  '$scope', '$state', '$window', 'CurrentPet', 'CurrentPlayer', 'CredentialCache', 'TurnTaker'
  ($scope, $state, $window, Pet, Player, CredentialCache, TurnTaker) ->

    if not Player.getPlayer()
      CredentialCache.tryLogin().then (->
          if not Player.getPlayer()
            $mdToast.show $mdToast.simple().position('top right').content('You don\'t appear to be logged in! Redirecting you to the login page...').action 'Close'
            $state.go 'login'

          else
            TurnTaker.beginTakingTurns Player.getPlayer()
        ),
        (->
          $mdToast.show $mdToast.simple().position('top right').content('You don\'t appear to be logged in! Redirecting you to the login page...').action 'Close'
          $state.go 'login'
        )

    $scope.xpPercent = 0
    $scope._ = $window._

    $window.scrollTo 0, document.body.scrollHeight

    $scope.calcXpPercent = ->
      $scope.xpPercent = if $scope.pet then ($scope.pet?.xp.__current / $scope.pet?.xp.maximum)*100 else 0

    # equipment page & overview page
    $scope.valueToColor = (value) ->
      return 'text-red' if value < 0
      return 'text-green' if value > 0

    $scope.initialize = ->
      $scope.calcXpPercent()

    Pet.observe().then null, null, (newVal) ->
      $scope.pet = newVal
      $scope.initialize()

    $scope.pet = Pet.getPet()
    $scope.initialize()

    $scope.selectedIndex = $state.current.data.selectedTab
]