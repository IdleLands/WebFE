angular.module 'IdleLands', ['ngMaterial', 'angularMoment', 'ui.router', 'LocalStorageModule', 'xeditable']

angular.module 'IdleLands'
  .run ['editableThemes', (editableThemes) ->
    editableThemes.default.cancelTpl = '<md-button class="xeditable-form-button md-theme-red" ng-click="$form.$cancel()">Cancel</md-button>'
    editableThemes.default.submitTpl = '<md-button class="xeditable-form-button md-theme-green" type="submit">Save</md-button>'
]

angular.module 'IdleLands'
  .config ['$locationProvider', ($loc) ->
    #$loc.html5Mode yes if window.history?.pushState
  ]