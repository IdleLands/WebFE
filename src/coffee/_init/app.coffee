angular.module 'IdleLands', ['ngMaterial', 'ngSanitize', 'angularMoment', 'ui.router', 'LocalStorageModule', 'xeditable', 'QuickList', 'angular-carousel']

angular.module 'IdleLands'
  .run ['editableThemes', 'editableOptions', (editableThemes, editableOptions) ->
    editableThemes['angular-material'] =
      formTpl:      '<form class="editable-wrap"></form>',
      noformTpl:    '<span class="editable-wrap"></span>',
      controlsTpl:  '<md-input-container class="editable-controls" ng-class="{\'md-input-invalid\': $error}"></md-input-container>',
      inputTpl:     '',
      errorTpl:     '<div ng-messages="{message: $error}"><div class="editable-error" ng-message="message">{{$error}}</div></div>',
      buttonsTpl:   '<span class="editable-buttons"></span>',
      submitTpl:    '<md-button class="md-primary md-raised" type="submit">save</md-button>',
      cancelTpl:    '<md-button class="md-warn md-raised" type="button" ng-click="$form.$cancel()">cancel</md-button>'

    editableOptions.theme = 'angular-material'
]

angular.module 'IdleLands'
  .config ['$locationProvider', ($loc) ->
    #$loc.html5Mode yes if window.history?.pushState
  ]
#window.location.protocol = 'https:' if window.location.host in ['idlelands.github.io', 'webfe.idle.land'] and window.location.protocol isnt 'https:'