angular.module 'IdleLands'
.controller 'PetInventory', [
  '$scope', 'CurrentPet', 'ItemUtilities', 'API'
  ($scope, Pet, ItemUtilities, API) ->

    $scope.itemUtilities = ItemUtilities

    $scope.canEquipItem = (item) ->
      return no if not _.contains $scope.petSlots, item.type
      return no if $scope.slotsTaken[item.type] is $scope.pet._configCache.slots[item.type]

      yes

    $scope.sortPetItems = ->
      $scope.petItems = $scope.pet.inventory

    $scope.itemItemScore = (item) ->
      return 0 if not item._baseScore or not item._calcScore
      parseInt (item._calcScore / item._baseScore) * 100

    $scope.petItemScore = (item) ->
      return 0 if not item._calcScore or not $scope.pet._baseStats.itemFindRange
      parseInt (item._calcScore / $scope.pet._baseStats.itemFindRange) * 100

    $scope.sellItem = (itemSlot) ->
      API.pet.sellItem {itemSlot: itemSlot}

    $scope.swapItem = (itemSlot) ->
      API.pet.takeItem {itemSlot: itemSlot}

    $scope.equipItem =  (item, itemSlot) ->
      return if not $scope.canEquipItem item
      API.pet.equipItem {itemSlot: itemSlot}

    $scope.initialize = ->
      $scope.petSlots = _.keys $scope.pet._configCache.slots
      $scope.slotsTaken = _.countBy $scope.pet.equipment, 'type'
      $scope.sortPetItems()

    Pet.observe().then null, null, ->
      $scope.initialize()

    $scope.initialize()

]