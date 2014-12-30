angular.module 'IdleLands'
.controller 'PlayerOptions', [
  '$scope', '$timeout', '$mdDialog', 'CurrentPlayer', 'OptionsCache', 'API'
  ($scope, $timeout, $mdDialog, Player, OptionsCache, API) ->

    initializing = yes

    $scope.options = OptionsCache.getOpts()

    $scope.strings =
      keys: []
      values: []

    # custom strings
    $scope.buildStringList = ->
      $scope.strings.keys = _.keys $scope.player?.messages
      $scope.strings.values = _.values $scope.player?.messages
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

    $scope.openSubmissionWindow = ->
      $mdDialog.show
        templateUrl: 'submit-content'
        controller: 'ContentSubmission'

    $scope.$watch 'strings', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.updateStrings()
    , yes

    $scope.$watch 'player.pushbulletApiKey', (newVal, oldVal) ->
      return if newVal is oldVal or initializing
      API.pushbullet.set {apiKey: newVal}

    $scope.$watch 'player.gender', (newVal, oldVal) ->
      return if newVal is oldVal or initializing
      API.gender.set {gender: newVal}

    isChanging = no
    $scope.$watch 'player.priorityPoints', (newVal, oldVal) ->
      return if newVal is oldVal or not oldVal

      propDiff = _.omit newVal, (v,k) -> oldVal[k] is v

      return if _.isEmpty propDiff

      _.each (_.keys propDiff), (prop) ->
        if $scope.player.priorityPoints[prop] < 0
          isChanging = yes
          $scope.player.priorityPoints[prop] = 0
          $timeout ->
            isChanging = no
          , 0
          return

        return if isChanging

        propDiff[prop] = newVal[prop] - oldVal[prop]

        return if (Math.abs propDiff[prop]) isnt 1

        isChanging = yes
        API.priority.add {stat: prop, points: propDiff[prop]}
        .then (res) ->
          if res.data.isSuccess
            isChanging = no
            return
          $scope.player.priorityPoints[prop] -= propDiff[prop]

          $timeout ->
            isChanging = no
          , 0
    , yes

    $scope.initialize = ->
      initializing = yes

      $scope.player = Player.getPlayer()
      $scope.buildStringList()

      $timeout ->
        initializing = no
      , 0

    Player.observe().then null, null, ->
      $scope.initialize()

    $scope.initialize()

]

angular.module 'IdleLands'
.controller 'ContentSubmission', [
  '$scope', '$mdDialog', '$mdToast', 'API'
  ($scope, $mdDialog, $mdToast, API) ->

    $scope.types = [
      {folder: 'events',      type: 'battle' }
      {folder: 'events',      type: 'blessGold' }
      {folder: 'events',      type: 'blessGoldParty' }
      {folder: 'events',      type: 'blessItem' }
      {folder: 'events',      type: 'blessXp' }
      {folder: 'events',      type: 'blessXpParty' }
      {folder: 'events',      type: 'enchant' }
      {folder: 'events',      type: 'findItem' }
      {folder: 'events',      type: 'flipStat' }
      {folder: 'events',      type: 'forsakeGold' }
      {folder: 'events',      type: 'forsakeItem' }
      {folder: 'events',      type: 'forsakeXp' }
      {folder: 'events',      type: 'levelDown' }
      {folder: 'events',      type: 'merchant' }
      {folder: 'events',      type: 'party' }
      {folder: 'events',      type: 'providence' }
      {folder: 'events',      type: 'tinker' }
      {folder: 'ingredients', type: 'bread',    requiresName: yes }
      {folder: 'ingredients', type: 'meat',     requiresName: yes }
      {folder: 'ingredients', type: 'veg',      requiresName: yes }
      {folder: 'items',       type: 'body',     requiresName: yes }
      {folder: 'items',       type: 'charm',    requiresName: yes }
      {folder: 'items',       type: 'feet',     requiresName: yes }
      {folder: 'items',       type: 'finger',   requiresName: yes }
      {folder: 'items',       type: 'hands',    requiresName: yes }
      {folder: 'items',       type: 'head',     requiresName: yes }
      {folder: 'items',       type: 'legs',     requiresName: yes }
      {folder: 'items',       type: 'mainhand', requiresName: yes }
      {folder: 'items',       type: 'neck',     requiresName: yes }
      {folder: 'items',       type: 'offhand',  requiresName: yes }
      {folder: 'items',       type: 'prefix',   requiresName: yes }
      {folder: 'items',       type: 'suffix',   requiresName: yes }
      {folder: 'monsters',    type: 'monster',  requiresName: yes }
    ]

    $scope.data = type: _.sample $scope.types

    $scope.cancel = $mdDialog.hide

    $scope.submit = ->
      data = $scope.data
      data._name = data._name?.trim()
      data.content = data.content?.trim()

      $mdToast.simple 'submitting...'

      requiresName = $scope.data.type.requiresName

      if not data.content
        $mdToast.show template: '<md-toast>You must have content!</md-toast>'
        return

      if requiresName and not data._name
        $mdToast.show template: '<md-toast>You must to specify a name!</md-toast>'
        return

      newData =
        type: $scope.data.type.type
        content: if requiresName then "\"#{data._name}\" #{data.content}" else data.content

      API.custom.submit data: newData
      .then (res) ->
        return if not res.data.isSuccess

        $mdDialog.hide()

      #API.pet.buyPet petAttrs
      #.then (res) ->
      #  return if not res.data.isSuccess
#
      #  $mdDialog.hide()
]