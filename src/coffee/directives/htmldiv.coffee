angular.module 'IdleLands'
.directive 'htmldiv', ['$compile', '$parse', ($compile, $parse) ->
  restrict: 'E'
  link: (scope, el, attr) ->
    scope.$watch attr.content, ->
      el.html $parse(attr.content)(scope)
      ($compile el.contents()) scope
    , yes
]