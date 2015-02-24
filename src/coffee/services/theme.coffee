angular.module 'IdleLands'
.factory 'CurrentTheme', [
  '$q', 'OptionsCache'
  ($q, OptionsCache) ->
    theme = (OptionsCache.loadOne 'theme') or 'default'
    defer = $q.defer()

    observe: -> defer.promise
    getTheme: -> theme
    setTheme: (newTheme) ->
      theme = newTheme
      OptionsCache.set 'theme', newTheme
      defer.notify theme

]