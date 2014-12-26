angular.module 'IdleLands', ['ngMaterial', 'ngSanitize', 'angularMoment', 'ui.router', 'LocalStorageModule', 'xeditable']

angular.module 'IdleLands'
  .run ['editableThemes', (editableThemes) ->
    editableThemes.default.cancelTpl = '<md-button class="xeditable-form-button md-theme-red" ng-click="$form.$cancel()">Cancel</md-button>'
    editableThemes.default.submitTpl = '<md-button class="xeditable-form-button md-theme-green" type="submit">Save</md-button>'
]

angular.module 'IdleLands'
  .config ['$locationProvider', ($loc) ->
    #$loc.html5Mode yes if window.history?.pushState
  ]

window.location = 'http://webfe.idle.land' if window.location.host is 'idlelands.github.io'
#window.location.protocol = 'https:' if window.location.host in ['idlelands.github.io', 'webfe.idle.land'] and window.location.protocol isnt 'https:'