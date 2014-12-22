angular.module 'IdleLands'
.controller 'Pet', [
  '$scope', '$state', '$window', '$mdDialog', '$timeout', 'Pet', 'Player', 'CredentialCache', 'TurnTaker'
  ($scope, $state, $window, $mdDialog, $timeout, Pet, Player, CredentialCache, TurnTaker) ->

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

    $scope.pets = []

    $window.scrollTo 0, document.body.scrollHeight

    $scope.calcXpPercent = ->
      $scope.xpPercent = ($scope.player.xp.__current / $scope.player.xp.maximum)*100

    initializing = yes

    $scope.tryToBuyPet = (type) ->
      $mdDialog.show
        templateUrl: 'buy-pet'
        controller: 'PetBuy'
        locals:
          petType: type
      .then (res) ->
        console.log res

    $scope.availablePets = ->
      pets = []

      _.each (_.keys $scope.player?.foundPets), (petKey) ->
        pet = $scope.player.foundPets[petKey]
        return if pet.purchaseDate
        pet.type = petKey
        pets.push pet

      pets

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

    $scope.$watch (->$state.current.data.selectedTab), (newVal) ->
      $timeout ->
        $scope.selectedIndex = newVal
      , 0
]

angular.module 'IdleLands'
.controller 'PetBuy', [
  '$scope', '$mdDialog'
  ($scope, $mdDialog) ->

    $scope.newPet = {}

    $scope.cancel = $mdDialog.hide

    $scope.purchase = ->
      $mdDialog.hide $scope.newPet
]