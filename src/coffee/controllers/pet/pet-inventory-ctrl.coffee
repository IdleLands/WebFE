angular.module 'IdleLands'
.controller 'PetInventory', [
  '$scope', 'CurrentPet', 'API'
  ($scope, Pet, API) ->

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

    $scope.extendedEquipmentStatArray = $scope.equipmentStatArray.concat {name: 'sentimentality'},
      {name: 'piety'},
      {name: 'enchantLevel'},
      {name: 'shopSlot'},
      {name: 'overflowSlot'},
      {name: 'uid'},
      {name: '_calcScore'},
      {name: '_baseScore'}

    $scope.classToColor = (itemClass) ->
      switch itemClass
        when 'newbie'   then return 'bg-maroon'
        when 'basic'    then return 'bg-gray'
        when 'pro'      then return 'bg-purple'
        when 'idle'     then return 'bg-rainbow'
        when 'godly'    then return 'bg-black'
        when 'custom'   then return 'bg-blue'
        when 'guardian' then return 'bg-cyan'
        when 'extra'    then return 'bg-orange'
        when 'total'    then return 'bg-teal'
        when 'shop'     then return 'bg-darkblue'

    $scope.getExtraStats = (item) ->
      keys = _.filter (_.compact _.keys item), (key) -> _.isNumber item[key]

      _.each $scope.extendedEquipmentStatArray, (stat) ->
        keys = _.without keys, stat.name
        keys = _.without keys, "#{stat.name}Percent"

      keys = _.reject keys, (key) -> item[key] is 0

      _.map keys, (key) -> "#{key} (#{item[key]})"
      .join ', '

    $scope.sortPetItems = ->
      $scope.petItems = _.sortBy $scope.pet.inventory, (item) -> item.type

    $scope.itemItemScore = (item) ->
      return 0 if not item._baseScore or not item._calcScore
      parseInt (item._calcScore / item._baseScore) * 100

    $scope.petItemScore = (item) ->
      return 0 if not item._calcScore or not $scope.player._baseStats.itemFindRange
      parseInt (item._calcScore / $scope.player._baseStats.itemFindRange) * 100

    #$scope.sellItem = (item) ->
    #  API.inventory.sell {invSlot: item.overflowSlot}
#
    #$scope.swapItem = (item) ->
    #  API.inventory.swap {invSlot: item.overflowSlot}
#
    #$scope.invItem =  (item) ->
    #  API.inventory.add {itemSlot: item.type}
#
    #$scope.buyItem =  (item) ->
    #  API.shop.buy {shopSlot: item.shopSlot}

    $scope.$watch (-> Pet.getPet()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)
      $scope.pet = newVal
      $scope.sortPetItems()

]