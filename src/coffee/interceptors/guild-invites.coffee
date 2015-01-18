angular.module 'IdleLands'
.factory 'GuildInvitesInterceptor', [
  'CurrentGuildInvites',
  (CurrentGuildInvites) ->
    response: (response) ->
      CurrentGuildInvites.setGuildInvites response.data.guildInvites if response.data.guildInvites
      response
]