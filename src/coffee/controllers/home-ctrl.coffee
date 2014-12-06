angular.module 'IdleLands'
.controller 'Home', [
  '$scope', '$state',
  ($scope, $state) ->
    $state.go 'player.overview'
]