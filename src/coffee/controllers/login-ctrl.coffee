angular.module 'IdleLands'
  .controller 'Login', [
    '$scope', '$state', 'API', 'CredentialCache', 'CurrentPlayer', 'TurnTaker', '$interval', 'EventIcons'
    ($scope, $state, API, CredentialCache, Player, TurnTaker, $interval, EventIcons) ->
      $scope.selectedIndex = 0
      $scope.selectTab = (tabIndex) -> $scope.selectedIndex = tabIndex

      goToPlayerView = ->
        $interval.cancel $scope.eventInt
        $state.go 'player.overview'

      if not Player.getPlayer()
        CredentialCache.tryLogin().then (->
            if Player.getPlayer()
              TurnTaker.beginTakingTurns Player.getPlayer()
              goToPlayerView()
          )

      $scope.login = {}
      $scope.register = {}
      $scope.advLogin = {}

      $scope.isSubmitting = no

      $scope.nameToIdentifier = (name) -> "web-fe##{name}"

      $scope.doLogin = ->
        data = _.clone $scope.login
        data.identifier = $scope.nameToIdentifier data.name
        $scope.sendLogin data

      $scope.doAdvancedLogin = ->
        $scope.sendLogin $scope.advLogin

      $scope.doRegister = ->
        $scope.isSubmitting = yes
        data = _.clone $scope.register
        data.identifier = $scope.nameToIdentifier data.name

        API.auth.register data
        .then (res) ->
          CredentialCache.setCreds data if res.data.isSuccess
          goToPlayerView()
          $scope.isSubmitting = no

      $scope.sendLogin = (data) ->
        $scope.isSubmitting = yes

        success = (res) ->
          if res.data.isSuccess
            CredentialCache.setCreds data
            goToPlayerView()
          $scope.isSubmitting = no

        failure = (res) ->
          $scope.isSubmitting = no

        API.auth.login data
        .then success, failure

      $scope.eventTypeToIcon = EventIcons
      $scope._events = []

      $scope.getEvents = (size = 'small')->
        opts = {}
        opts.newerThan = new Date($scope._events[0].createdAt).getTime() if $scope._events.length > 0
        (API.events[size] opts)
        .then (res) ->
          $scope._events.unshift res.data.events...
          $scope._events.length = 200 if $scope._events.length > 200

      $scope.getEvents 'medium'
      $scope.eventInt = $interval ($scope.getEvents.bind null, 'small'), 5200
  ]