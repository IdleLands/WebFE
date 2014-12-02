angular.module 'IdleLands'
.controller 'PlayerOverview', [
  '$scope', '$timeout', '$state', 'Player', 'API', 'CurrentBattle'
  ($scope, $timeout, $state, Player, API, CurrentBattle) ->

    initializing = yes

    $scope.personalityToggle = {}

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

    # click on button
    $scope.clickOnEvent = (extraData) ->
      $scope.retrieveBattle extraData.battleId if extraData.battleId

    # battle
    $scope.retrieveBattle = (id) ->
      API.battle.get {battleId: id}
      .then (res) ->
        CurrentBattle.setBattle res.data.battle
        $state.go 'player.battle' if res.data.battle

    $scope.loadPersonalities = ->
      _.each $scope.player.personalityStrings, (personality) ->
        $scope.personalityToggle[personality] = yes

    $scope.setPersonality = (personality, to) ->
      func = if to then 'add' else 'remove'
      key = if to then 'newPers' else 'oldPers'

      props = {}
      props[key] = personality

      API.personality[func] props

    $scope.$watchCollection 'personalityToggle', (newVal, oldVal) ->
      return if initializing or newVal is oldVal

      propDiff = _.omit newVal, (v,k) -> oldVal[k] is v

      _.each (_.keys propDiff), (pers) ->
        $scope.setPersonality pers, propDiff[pers]

    $scope.$watch (-> Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)

      initializing = yes

      $scope.player = newVal
      $scope.loadPersonalities()

      $timeout ->
        initializing = no
      , 0

]