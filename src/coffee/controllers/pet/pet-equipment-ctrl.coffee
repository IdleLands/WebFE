angular.module 'IdleLands'
.controller 'PetEquipment', [
  '$scope', 'CurrentPet', 'ItemUtilities', 'API'
  ($scope, Pet, ItemUtilities, API) ->

    $scope.itemUtilities = ItemUtilities

    $scope.sortPetItems = ->
      $scope.petItems = $scope.pet.inventory

    $scope.itemItemScore = (item) ->
      return 0 if not item._baseScore or not item._calcScore
      parseInt (item._calcScore / item._baseScore) * 100

    $scope.petItemScore = (item) ->
      return 0 if not item._calcScore or not $scope.player._baseStats.itemFindRange
      parseInt (item._calcScore / $scope.player._baseStats.itemFindRange) * 100

    $scope.sellItem = (item) ->
      API.pet.sellItem {itemslot: item.overflowSlot}

    $scope.swapItem = (item) ->
      #API.pet.swap {invSlot: item.overflowSlot}

    $scope.equipItem =  (item) ->
      #API.pet.add {itemSlot: item.type}

    $scope.$watch (-> Pet.getPet()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)
      $scope.pet = newVal
      $scope.sortPetItems()

]