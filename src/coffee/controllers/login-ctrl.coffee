angular.module 'IdleLands'
  .controller 'Login', [
    '$scope', '$state', 'API', 'CredentialCache',
    ($scope, $state, API, CredentialCache) ->
      $scope.selectedIndex = 0
      $scope.selectTab = (tabIndex) -> $scope.selectedIndex = tabIndex

      $scope.login = {}
      $scope.register = {}
      $scope.advLogin = {}

      $scope.isSubmitting = no

      $scope.nameToIdentifier = (name) -> "web-fe##{name}"

      goToPlayerView = ->
        $state.go 'player.overview'

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
  ]