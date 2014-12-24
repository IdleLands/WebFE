angular.module 'IdleLands'
.controller 'PetOverview', [
  '$scope', '$timeout', '$mdDialog', 'CurrentPet', 'CurrentPets', 'CurrentPlayer', 'API', '$state',
  ($scope, $timeout, $mdDialog, Pet, Pets, Player, API, $state) ->

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

    $scope.getGenderFor = (player) ->
      switch player.gender
        when 'male' then 'male'
        when 'female' then 'female'
        else 'question'

    $scope.getTypeIcon = (pet) ->
      switch pet._configCache.category
        when 'Non-Combat' then 'book'
        when 'Combat' then 'bomb'
        else 'adjust'

    $scope.pets = []

    $scope.toPlayerView = ->
      $state.go 'player.overview'

    $scope.boughtPets = ->
      pets = 0
      _.each (_.keys $scope.player.foundPets), (petKey) ->
        pets++ if $scope.player.foundPets[petKey].purchaseDate

      pets

    $scope.availablePets = ->
      pets = []

      _.each (_.keys $scope.player?.foundPets), (petKey) ->
        pet = $scope.player.foundPets[petKey]
        return if pet.purchaseDate
        pet.type = petKey
        pets.push pet

      pets

    $scope.tryToBuyPet = (pet) ->
      return if not $scope.canBuyPet pet
      $mdDialog.show
        templateUrl: 'buy-pet'
        controller: 'PetBuy'
        locals:
          petType: pet.type

    $scope.canBuyPet = (pet) ->
      pet.cost <= $scope.player.gold.__current

    $scope.getSmartIcon = (type) ->
      return if not $scope.pet
      if $scope.pet["smart#{type}"] then 'check' else 'remove'

    $scope.toggleSmart = (type) ->
      type = "smart#{type}"
      API.pet.setSmart
        option: type
        value: not $scope.pet[type]

    $scope.doPetSwap = (newPetUid) ->
      API.pet.swapToPet petId: newPetUid

    $scope.feedPet = ->
      API.pet.feedPet()

    $scope.takePetGold = ->
      API.pet.takeGold()

    $scope.upgradeStat = (stat) ->
      API.pet.upgradePet stat: stat

    $scope.petUpgradeData =
      inventory:
        stat: 'Inventory Size'
        gift: 'Inventory size is %gift'

      maxLevel:
        stat: 'Max Level'
        gift: 'Max level is %gift'

      goldStorage:
        stat: 'Gold Storage'
        gift: 'Gold storage is %gift'

      battleJoinPercent:
        stat: 'Combat Aid Chance'
        gift: 'Battle join chance is %gift'

      itemFindBonus:
        stat: 'Item Find Bonus'
        gift: 'Bonus to found items is %gift'

      itemFindTimeDuration:
        stat: 'Item Find Time'
        gift: 'New item every %gifts'

      itemSellMultiplier:
        stat: 'Item Sell Bonus'
        gift: 'Sell bonus is %gift'

      itemFindRangeMultiplier:
        stat: 'Item Equip Bonus'
        gift: 'Bonus to equipping is %gift'

      maxItemScore:
        stat: 'Max Item Score'
        gift: 'Highest findable score is %gift'

      xpPerGold:
        stat: 'XP / gold'
        gift: 'Gain %gift xp per gold fed to pet'

    $scope.formatGift = (key, gift) ->
      switch key
        when 'battleJoinPercent' then "#{gift}%"
        when 'goldStorage' then _.str.numberFormat gift
        when 'itemFindBonus' then "+#{gift}"
        when 'itemFindRangeMultiplier', 'itemSellMultiplier' then "#{Math.round gift*100}%"
        else gift

    $scope.getPetsInOrder = ->
      _.sortBy $scope.pets, (pet) -> not pet.isActive

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

    $scope.$watch (-> Pets.getPets()), (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.pets = newVal
]

angular.module 'IdleLands'
.controller 'PetBuy', [
  '$scope', '$mdDialog', 'petType', 'API'
  ($scope, $mdDialog, petType, API) ->

    $scope.newPet =
      name: ''
      attr1: 'a monocle'
      attr2: 'a top hat'

    $scope.petType = petType

    $scope.cancel = $mdDialog.hide

    $scope.purchase = ->
      petAttrs =
        type: petType
        attrs: [$scope.newPet.attr1, $scope.newPet.attr2]
        name: $scope.newPet.name

      API.pet.buyPet petAttrs
      .then (res) ->
        return if not res.data.isSuccess

        $mdDialog.hide()
]