angular.module 'IdleLands'
.factory 'CurrentGuild', [
  '$q'
  ($q) ->
    guild = null
    defer = $q.defer()

    observe: -> defer.promise
    getGuild: -> guild
    setGuild: (newGuild) ->
      guild = newGuild
      defer.notify guild

]