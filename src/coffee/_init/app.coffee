angular.module 'IdleLands', ['ngMaterial', 'ngResource', 'angularMoment', 'ui.router', 'LocalStorageModule']

angular.module 'IdleLands'
  .config ['$locationProvider', ($loc) ->
    #$loc.html5Mode yes if window.history?.pushState
  ]