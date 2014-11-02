angular.module 'IdleLands'
  .directive 'statisticsTree', ['$parse', '$timeout', ($parse, $timeout) ->
    restrict: 'E'
    templateUrl: 'statistics-template'
    scope:
      stats: '='
      root: '='
      family: '='
    link: (scope) ->

      stripFamily = (str, family) ->
        (str.substring family.length).trim()

      scope.$watch 'stats', (newVal, oldVal) ->
        return if newVal is oldVal
        scope.orderedData = []
        sortedStats = _.sortBy scope.stats, (stat) -> stat

        _.each sortedStats, (stat) ->
          stripName = stripFamily stat, scope.family
          return if not stripName

          data = scope.root[stat]
          scope.orderedData.push name: stripName, value: (if _.isPlainObject data then '' else data), alignment: 'left'

          if _.isPlainObject data
            sortedKeys = (_.keys data).sort()
            _.each sortedKeys, (subkey) ->
              scope.orderedData.push name: subkey, value: data[subkey], alignment: 'right'
  ]