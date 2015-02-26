angular.module 'IdleLands'
.controller 'PlayerOptions', [
  '$scope', '$timeout', '$mdDialog', 'CurrentPlayer', 'OptionsCache', 'API', 'CurrentTheme'
  ($scope, $timeout, $mdDialog, Player, OptionsCache, API, CurrentTheme) ->

    $scope.options = OptionsCache.getOpts()

    $scope.strings =
      keys: []
      values: []

    $scope.scrollbackPos = (OptionsCache.loadOne 'scrollbackPos') or 'right'

    baseScrollbackClass = ''

    handleScrollbackPosition = ->
      el = angular.element '.scrollback-toast'
      baseScrollbackClass = el.attr 'class' unless baseScrollbackClass
      el
        .attr 'class', baseScrollbackClass
        .addClass "scrollback-#{$scope.scrollbackPos}"

    $scope.changeScrollbackPosition = ->
      OptionsCache.set 'scrollbackPos', $scope.scrollbackPos
      handleScrollbackPosition()

    $timeout handleScrollbackPosition, 3000

    # themes
    $scope.theme = CurrentTheme.getTheme()

    $scope.themes = [
      'bright'
      'default'
      'dim-ocean'
      'earth'
      'green-machine'
      'halloween'
      'majestic'
      'monochrome'
      'ocean'
      'simple'
    ]

    $scope.changeTheme = ->
      CurrentTheme.setTheme $scope.theme

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

    $scope.openModerationWindow = ->
      $mdDialog.show
        templateUrl: 'moderate-content'
        controller: 'ContentModeration'
        escapeToClose: no
        clickOutsideToClose: no

      .then ->
        $scope.refreshCustomContent()

    $scope.$watch 'strings', (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.updateStrings()
    , yes

    $scope.updatePushbullet = ->
      API.pushbullet.set {apiKey: $scope.player.pushbulletApiKey}
      yes

    $scope.updateGender = ->
      API.gender.set {gender: $scope.player.gender}
      yes

    $scope.tempPP = {}

    $scope.updatePP = (stat) ->
      oldVal = $scope.tempPP[stat]
      newVal = $scope.player.priorityPoints[stat]
      diff = newVal - oldVal

      return if diff is 0

      $scope.tempPP[stat] += diff

      API.priority.add {stat: stat, points: diff}
      .then (res) ->
        if not res.data.isSuccess
          $scope.player.priorityPoints[stat] = oldVal
          $scope.tempPP[stat] -= diff

    $scope.refreshCustomContent = ->
      API.custom.list()
      .then (res) ->
        $scope.customContentList = res.data.customs

    $scope.initialize = ->
      $scope.player = Player.getPlayer()
      $scope.buildStringList()

      $scope.refreshCustomContent() if $scope.player?.isContentModerator and not $scope.customContentList

    Player.observe().then null, null, ->
      $scope.initialize()

    $scope.initialize()

]

angular.module 'IdleLands'
.controller 'ContentModeration', [
  '$scope', '$mdDialog', 'API'
  ($scope, $mdDialog, API) ->
    $scope.cancel = $mdDialog.hide

    $scope.toggleAll = ->
      _.each $scope.customContentList, (item) ->
        item.currentlySelected = not item.currentlySelected

    do $scope.refreshData = ->
      API.custom.list()
      .then (res) ->
        $scope.customContentList = res.data.customs

    getSelected = ->
      _($scope.customContentList)
        .filter (item) -> item.currentlySelected
        .map (item) -> item._id
        .value()

    $scope.approve = ->
      API.custom.approve ids: getSelected()
      .then ->
        $scope.refreshData()

    $scope.reject = ->
      API.custom.reject ids: getSelected()
      .then ->
        $scope.refreshData()

]

angular.module 'IdleLands'
.controller 'ContentSubmission', [
  '$scope', '$mdDialog', '$mdToast', 'API'
  ($scope, $mdDialog, $mdToast, API) ->

    $scope.folders = [
      'events'
      'ingredients'
      'items'
      'monsters'
      'npcs'
    ]

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
      {folder: 'events',      type: 'towncrier' }
      {folder: 'ingredients', type: 'bread',    requiresName: yes, requiresContent: yes }
      {folder: 'ingredients', type: 'meat',     requiresName: yes, requiresContent: yes }
      {folder: 'ingredients', type: 'veg',      requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'body',     requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'charm',    requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'feet',     requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'finger',   requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'hands',    requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'head',     requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'legs',     requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'mainhand', requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'neck',     requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'offhand',  requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'prefix',   requiresName: yes, requiresContent: yes }
      {folder: 'items',       type: 'suffix',   requiresName: yes, requiresContent: yes }
      {folder: 'monsters',    type: 'monster',  requiresName: yes, requiresContent: yes }
      {folder: 'npcs',        type: 'trainer',  requiresName: yes }
    ]

    $scope.data = type: _.sample $scope.types

    $scope.cancel = $mdDialog.hide

    $scope.submit = ->
      data = $scope.data
      data._name = data._name?.trim()
      data.content = data.content?.trim() or ''

      requiresName = $scope.data.type.requiresName
      requiresContent = $scope.data.type.requiresContent

      if not data.content and requiresContent
        $mdToast.show $mdToast.simple().position('top right').content('You must have content!').action 'Close'
        return

      if requiresName and not data._name
        $mdToast.show $mdToast.simple().position('top right').content('You must to specify a name!').action 'Close'
        return

      newData =
        type: $scope.data.type.type
        content: if requiresName then "\"#{data._name}\" #{data.content}" else data.content

      API.custom.submit data: newData
      .then (res) ->
        return if not res.data.isSuccess

        $mdDialog.hide()
]