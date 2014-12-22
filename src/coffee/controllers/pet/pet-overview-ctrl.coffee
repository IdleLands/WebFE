angular.module 'IdleLands'
.controller 'PetOverview', [
  '$scope', '$timeout', 'Pet', 'Player', '$state',
  ($scope, $timeout, Pet, Player, $state) ->

    initializing = yes

    $scope.equipmentStatArray = [
      {name: 'str', fa: 'fa-legal fa-rotate-90'}
      {name: 'dex', fa: 'fa-crosshairs'}
      {name: 'agi', fa: 'fa-bicycle'}
      {name: 'con', fa: 'fa-heart'}
      {name: 'int', fa: 'fa-mortar-board'}
      {name: 'wis', fa: 'fa-book'}
      {name: 'luck', fa: 'fa-moon-o'}
      {name: 'fire', fa: 'fa-fire'}
      {name: 'water', fa: 'icon-water'}
      {name: 'thunder', fa: 'fa-bolt'}
      {name: 'earth', fa: 'fa-leaf'}
      {name: 'ice', fa: 'icon-snow'}
    ]

    $scope.toPlayerView = ->
      $state.go 'player.overview'

    $scope.boughtPets = ->
      pets = 0
      _.each (_.keys $scope.player.foundPets), (petKey) ->
        pets++ if $scope.player.foundPets[petKey].purchaseDate

      pets

    $scope.$watch (-> Pet.getPet()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)

      initializing = yes

      $scope.pet = newVal

      $timeout ->
        initializing = no
      , 0

    $scope.$watch (-> Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.player = newVal

]