angular.module 'IdleLands'
.controller 'PetInventory', [
  '$scope', 'CurrentPet', 'ItemUtilities', 'API'
  ($scope, Pet, ItemUtilities, API) ->

    $scope.itemUtilities = ItemUtilities

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

    $scope.equipItem =  (itemSlot) ->
      API.pet.equipItem {itemSlot: itemSlot}

    $scope.$watch (-> Pet.getPet()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)
      $scope.pet = newVal
      $scope.sortPetItems()

]