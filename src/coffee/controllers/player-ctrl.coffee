angular.module 'IdleLands'
.controller 'Player', [
  '$scope', '$state', '$window', '$timeout', '$mdToast', 'API', 'Player', 'TurnTaker' ,'CredentialCache', 'OptionsCache', 'BattleColorMap', 'CurrentMap', 'BaseURL'
  ($scope, $state, $window, $timeout, $mdToast, API, Player, TurnTaker, CredentialCache, OptionsCache, BattleColorMap, CurrentMap, BaseURL) ->

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

    OptionsCache.load ['scrollback']
    $scope.options = OptionsCache.getOpts()

    $scope.personalityToggle = {}
    $scope.strings =
      keys: []
      values: []
    $scope._player = Player
    $scope.xpPercent = 0
    $scope.selectedIndex = 0
    $scope.statisticsKeys = {}
    $scope._ = $window._
    $scope.currentMap = {}

    $window.scrollTo 0, document.body.scrollHeight

    $scope.selectTab = (tabIndex) ->
      $scope.selectedIndex = tabIndex

    $scope.calcXpPercent = ->
      $scope.xpPercent = ($scope.player.xp.__current / $scope.player.xp.maximum)*100

    $scope.sortPlayerItems = ->
      $scope.playerItems = (_.sortBy ($scope.getEquipmentAndTotals $scope.player.equipment), (item) -> item.type).concat $scope.getOverflows()

    initializing = yes

    $scope.loadPersonalities = ->
      _.each $scope.player.personalityStrings, (personality) ->
        $scope.personalityToggle[personality] = yes

    $scope.setPersonality = (personality, to) ->
      func = if to then 'add' else 'remove'
      key = if to then 'newPers' else 'oldPers'

      props = {}
      props[key] = personality

      API.personality[func] props

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

    $scope.eventTypeToIcon =
      'item-mod': ['fa-legal','fa-magic fa-rotate-90']
      'item-find': ['icon-feather']
      'item-enchant': ['fa-magic']
      'item-switcheroo': ['icon-magnet']
      'shop': ['fa-money']
      'shop-fail': ['fa-money']
      'profession': ['fa-child']
      'explore': ['fa-globe']
      'levelup': ['icon-universal-access']
      'achievement': ['fa-shield']
      'party': ['fa-users']
      'exp': ['fa-support']
      'gold': ['icon-money']
      'guild': ['fa-network']
      'combat': ['fa-newspaper-o faa-pulse animated']

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
      {name: 'shopSlot'},
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

    $scope.logout = ->
      Player.setPlayer null
      CredentialCache.doLogout()
      API.auth.logout()
      $state.go 'login'

    # map
    sprite = null
    game = null
    mapName = null
    newMapName = null

    $scope.drawMap = ->
      return if _.isEmpty $scope.currentMap
      player = $scope.player

      newMapName = player.map if not newMapName

      if sprite
        sprite.x = (player.x*16)
        sprite.y = (player.y*16)
        game.camera.x = sprite.x
        game.camera.y = sprite.y

        if player.map isnt mapName
          newMapName = player.map
          mapName = player.map
          game.state.restart()

      phaserOpts =
        preload: ->
          #gah, github. whatever.
          @game.load.image 'tiles', "#{BaseURL}/img/tiles.png", 16, 16
          @game.load.spritesheet 'interactables', "#{BaseURL}/img/tiles.png", 16, 16
          @game.load.tilemap newMapName, null, $scope.currentMap.map, Phaser.Tilemap.TILED_JSON

        create: ->
          map = @game.add.tilemap newMapName
          map.addTilesetImage 'tiles', 'tiles'
          terrain = map.createLayer 'Terrain'
          terrain.resizeWorld()
          map.createLayer 'Blocking'

          for i in [1, 2, 12, 13, 14, 15, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 35]
            map.createFromObjects 'Interactables', i, 'interactables', i-1

          sprite = @game.add.sprite player.x*16, player.y*16, 'interactables', 12
          @game.camera.follow sprite

      return if (not player) or game
      $timeout ->
        game = new Phaser.Game '100%', '100%', Phaser.CANVAS, 'map', phaserOpts
      , 0
      null

    # equipment page
    $scope.valueToColor = (value) ->
      return 'text-red' if value < 0
      return 'text-green' if value > 0

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

    # custom strings
    $scope.buildStringList = ->
      $scope.strings.keys = _.keys $scope.player.messages
      $scope.strings.values = _.values $scope.player.messages
      $scope.strings.keys.push ''

    $scope.updateStrings = ->
      oldVal = $scope.player.messages or {}
      newVal = _.zipObject $scope.strings.keys, $scope.strings.values

      propDiff = _.omit newVal, (v,k) -> oldVal[k] is v

      return if _.isEmpty propDiff
      $scope.player.messages = newVal

      _.each (_.keys propDiff), (key) ->
        API.strings.set {type: key, msg: propDiff[key]}

      $scope.buildStringList()

    $scope.removeString = (key, index) ->
      API.strings.remove {type: key}
      .then ->
        $scope.strings.keys = _.reject $scope.strings.keys, (key, kI) -> index is kI
        $scope.strings.values = _.reject $scope.strings.values, (key, kI) -> index is kI
        $scope.player.messages = _.omit $scope.player.messages, key

        $scope.buildStringList()

    # click on button
    $scope.clickOnEvent = (extraData) ->
      $scope.retrieveBattle extraData.battleId if extraData.battleId

    # battle
    $scope.retrieveBattle = (id) ->
      API.battle.get {battleId: id}
      .then (res) ->
        $scope.currentBattle = res.data.battle
        $scope.selectTab 3 if $scope.currentBattle

    $scope.filterMessage = (message) ->
      for search, replaceFunc of BattleColorMap
        regexp = new RegExp "(<#{search}>)([\\s\\S]*?)(<\\/#{search}>)", 'g'
        message = message.replace regexp, (match, p1, p2) ->
          replaceFunc p2

      message

    # player statistics page
    $scope.getAllStatisticsInFamily = (family) ->
      return if not $scope.player
      base = _.omit $scope.player.statistics, (value, key) ->
        key.indexOf(family) isnt 0

      $scope.statisticsKeys[family] = _.keys base

    # scrollback
    $scope.handleScrollback = ->
      classFunc = if $scope.options.scrollback is 'true' then 'removeClass' else 'addClass'
      scrollback = (angular.element '.scrollback-toast')[classFunc] 'hidden'

    $timeout $scope.handleScrollback, 3000

    # watches
    $scope.$watch (-> TurnTaker.getSeconds()), (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.turnTimeValue = newVal * 10

    $scope.$watch 'strings', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.updateStrings()
    , yes

    $scope.$watchCollection 'personalityToggle', (newVal, oldVal) ->
      return if initializing or newVal is oldVal

      propDiff = _.omit newVal, (v,k) -> oldVal[k] is v

      _.each (_.keys propDiff), (pers) ->
        $scope.setPersonality pers, propDiff[pers]

    $scope.$watch 'options', (newVal, oldVal) ->
      return if newVal is oldVal
      OptionsCache.saveAll()
      $scope.handleScrollback()
    , yes

    $scope.$watch 'player.pushbulletApiKey', (newVal, oldVal) ->
      return if newVal is oldVal or initializing
      API.pushbullet.set {apiKey: newVal}
      
    $scope.$watch 'player.gender', (newVal, oldVal) ->
      return if newVal is oldVal or initializing
      API.gender.set {gender: newVal}

    $scope.$watch '_player.getPlayer()', (newVal, oldVal) ->
      return if newVal is oldVal

      initializing = yes

      $scope.player = newVal
      $window.scrollback.nick = newVal.name
      $scope.calcXpPercent()
      $scope.sortPlayerItems()
      $scope.loadPersonalities()
      $scope.buildStringList()

      _.each ['calculated', 'combat self', 'event', 'explore', 'player'], $scope.getAllStatisticsInFamily

      $timeout ->
        initializing = no
      , 0

    $scope.$watch (-> CurrentMap.getMap()), (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.currentMap = newVal
]