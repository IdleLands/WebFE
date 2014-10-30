angular.module 'IdleLands'
.controller 'Player', [
  '$scope', '$state', '$mdToast', 'API', 'Player', 'TurnTaker' ,'CredentialCache',
  ($scope, $state, $mdToast, API, Player, TurnTaker, CredentialCache) ->

    if not Player.getPlayer()
      CredentialCache.tryLogin().then (-> TurnTaker.beginTakingTurns Player.getPlayer()),
        (->
          $mdToast.show template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
          $state.go 'login'
        )

    $scope.selectedIndex = 0
    $scope.selectTab = (tabIndex) -> $scope.selectedIndex = tabIndex

    $scope.xpPercent = 0
    $scope.calcXpPercent = ->
      $scope.xpPercent = ($scope.player.xp.__current / $scope.player.xp.maximum)*100

    $scope.sortPlayerItems = ->
      $scope.playerItems = (_.sortBy ($scope.getEquipmentAndTotals $scope.player.equipment), (item) -> item.type).concat $scope.getOverflows()

    $scope.classToColor = (itemClass) ->
      switch itemClass
        when 'newbie' then return 'bg-maroon'
        when 'basic'  then return 'bg-gray'
        when 'pro'    then return 'bg-purple'
        when 'idle'   then return 'bg-rainbow'
        when 'godly'  then return 'bg-black'
        when 'custom' then return 'bg-blue'
        when 'extra'  then return 'bg-orange'
        when 'total'  then return 'bg-teal'

    $scope.equipmentStatArray = [
      {name: 'str', fa: 'fa-legal fa-rotate-90'}
      {name: 'dex', fa: 'fa-crosshairs'}
      {name: 'agi', fa: 'fa-bicycle'}
      {name: 'con', fa: 'fa-heart'}
      {name: 'int', fa: 'fa-mortar-board'}
      {name: 'wis', fa: 'fa-book'}
      {name: 'fire', fa: 'fa-fire'}
      {name: 'water', fa: 'icon-water'}
      {name: 'thunder', fa: 'fa-bolt'}
      {name: 'earth', fa: 'fa-leaf'}
      {name: 'ice', fa: 'icon-snow'}
      {name: 'luck', fa: 'fa-moon-o'}
    ]

    $scope.achievementTypeToIcon =
      'class': ['fa-child']
      'event': ['fa-info']
      'combat': ['fa-legal','fa-magic fa-rotate-90']
      'special': ['fa-gift']
      'personality': ['fa-group']
      'exploration': ['fa-compass']
      'progress': ['fa-signal']

    $scope.extendedEquipmentStatArray = $scope.equipmentStatArray.concat {name: 'sentimentality'},
      {name: 'piety'},
      {name: 'enchantLevel'},
      {name: '_calcScore'},
      {name: '_baseScore'}

    $scope.getExtraStats = (item) ->
      keys = _.filter (_.compact _.keys item), (key) -> _.isNumber item[key]

      _.each $scope.extendedEquipmentStatArray, (stat) ->
        keys = _.without keys, stat.name
        keys = _.without keys, "#{stat.name}Percent"

      keys = _.reject keys, (key) -> item[key] is 0

      _.map keys, (key) -> "#{key} (#{item[key]})"
      .join ', '

    $scope.getEquipmentAndTotals = (items) ->

      test = _.reduce items, (prev, cur) ->
        for key, val of cur
          prev[key] = 0 if not (key of prev) and _.isNumber val
          prev[key] += val if _.isNumber val
        prev
      , {name: 'Equipment Stat Totals', type: 'TOTAL', itemClass: 'total'}

      items.unshift test

      items

    $scope.getOverflows = ->

      items = []
      overflow = $scope.player.overflow

      if overflow
        _.each overflow, (item, index) ->
          item.extraItemClass = 'extra'
          item.extraText = "SLOT #{index}"
          items.push item

      items

    $scope.valueToColor = (value) ->
      return 'text-red' if value < 0
      return 'text-green' if value > 0

    $scope.itemItemScore = (item) ->
      return 0 if not item._baseScore or not item._calcScore
      parseInt (item._calcScore / item._baseScore) * 100

    $scope.playerItemScore = (item) ->
      return 0 if not item._calcScore or not $scope.player._baseStats.itemFindRange
      parseInt (item._calcScore / $scope.player._baseStats.itemFindRange) * 100

    $scope._player = Player

    $scope.$watch '_player.getPlayer()', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.player = newVal

      $scope.calcXpPercent()
      $scope.sortPlayerItems()
]