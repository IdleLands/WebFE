angular.module 'IdleLands'
.controller 'PetEquipment', [
  '$scope', 'CurrentPet', 'ItemUtilities', 'API'
  ($scope, Pet, ItemUtilities, API) ->

    $scope.itemUtilities = ItemUtilities

    $scope.organizePetItems = ->
      $scope.sortedPetEquipment = _($scope.pet.equipment)
        .reject (item) -> item.type is 'pet soul'
        .sortBy (item) -> item.type
        .value()

    $scope.getPetSoulAndTotals = ->

      oldItems = $scope.petItems

      items = []

      test = _.reduce oldItems, (prev, cur) ->
        for key, val of cur
          prev[key] = 0 if not (key of prev) and _.isNumber val
          prev[key] += val if _.isNumber val
        prev
      , {name: 'Equipment Stat Totals', type: 'TOTAL', itemClass: 'total', hideButtons: yes}

      items.push test

      petSoul = _.findWhere oldItems, {type: 'pet soul'}
      petSoul.hideButtons = yes
      items.push petSoul

      items

    $scope.sortPetItems = ->
      $scope.petItems = $scope.pet.equipment
      $scope.petSoulEtc = $scope.getPetSoulAndTotals()
      $scope.organizePetItems()

    $scope.itemItemScore = (item) ->
      return 0 if not item._baseScore or not item._calcScore
      parseInt (item._calcScore / item._baseScore) * 100

    $scope.petItemScore = (item) ->
      return 0 if not item._calcScore or not $scope.player._baseStats.itemFindRange
      parseInt (item._calcScore / $scope.player._baseStats.itemFindRange) * 100

    $scope.unequipItem = (item) ->
      API.pet.unequipItem {itemUid: item.uid}

    Pet.observe().then null, null, ->
      $scope.sortPetItems()

    $scope.sortPetItems()

]