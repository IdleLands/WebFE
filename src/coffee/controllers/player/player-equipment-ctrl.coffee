angular.module 'IdleLands'
.controller 'PlayerEquipment', [
  '$scope', 'CurrentPlayer', 'ItemUtilities', 'API'
  ($scope, Player, ItemUtilities, API) ->

    $scope.itemUtilities = ItemUtilities

    $scope.getEquipmentAndTotals = (oldItems) ->

      items = _.clone oldItems

      test = _.reduce items, (prev, cur) ->
        for key, val of cur
          prev[key] = 0 if not (key of prev) and _.isNumber val
          prev[key] += val if _.isNumber val
        prev
      , {name: 'Equipment Stat Totals', type: 'TOTAL', itemClass: 'total', hideButtons: yes}

      items.unshift test

      items

    $scope.getOverflows = ->

      items = []

      shop = $scope.player.shop
      if shop
        _.each shop.slots, (slot, index) ->
          item = slot.item
          item.cost = slot.price

          item.extraItemClass = 'shop'
          item.extraText = "SHOP #{index}"
          item.shopSlot = index
          items.push item

      overflow = $scope.player.overflow

      if overflow
        _.each overflow, (item, index) ->
          return if not item
          item.extraItemClass = 'extra'
          item.extraText = "SLOT #{index}"
          item.overflowSlot = index
          items.push item

      items

    $scope.sortPlayerItems = ->
      $scope.playerItems = (_.sortBy ($scope.getEquipmentAndTotals $scope.player.equipment), (item) -> item.type).concat $scope.getOverflows()

    $scope.itemItemScore = (item) ->
      return 0 if not item._baseScore or not item._calcScore
      parseInt (item._calcScore / item._baseScore) * 100

    $scope.playerItemScore = (item) ->
      return 0 if not item._calcScore or not $scope.player._baseStats.itemFindRange
      parseInt (item._calcScore / $scope.player._baseStats.itemFindRange) * 100

    $scope.sellItem = (item) ->
      API.inventory.sell {invSlot: item.overflowSlot}

    $scope.swapItem = (item) ->
      API.inventory.swap {invSlot: item.overflowSlot}

    $scope.invItem =  (item) ->
      API.inventory.add {itemSlot: item.type}

    $scope.buyItem =  (item) ->
      API.shop.buy {shopSlot: item.shopSlot}

    $scope.sendToPet =(item) ->
      API.pet.giveItem {itemSlot: item.overflowSlot}

    $scope.$watch (-> Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)
      $scope.player = newVal
      $scope.sortPlayerItems()

]