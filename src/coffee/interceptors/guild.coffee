angular.module 'IdleLands'
.factory 'GuildInterceptor', [
  'CurrentGuild',
  (CurrentGuild) ->
    response: (response) ->
      CurrentGuild.setGuild response.data.guild if response.data.guild
      response
]