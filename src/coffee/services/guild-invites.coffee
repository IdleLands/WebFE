angular.module 'IdleLands'
.factory 'CurrentGuildInvites', [
  '$q'
  ($q) ->
    guildInvites = null
    defer = $q.defer()

    observe: -> defer.promise
    getGuildInvites: -> guildInvites
    setGuildInvites: (newGuildInvites) ->
      guildInvites = newGuildInvites
      defer.notify guildInvites

]