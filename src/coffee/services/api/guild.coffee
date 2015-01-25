angular.module 'IdleLands'
.factory 'Guild', [
  '$http', 'BaseURL',
  ($http, baseURL) ->
  
    url = "#{baseURL}/guild"
    inviteUrl = "#{url}/invite"
    manageUrl = "#{url}/manage"
    
    create:       (data) -> $http.put  "#{url}/create", data
    leave:        (data) -> $http.post "#{url}/leave", data
    disband:      (data) -> $http.put  "#{url}/disband", data

    invite:       (data) -> $http.put  "#{inviteUrl}/player", data
    manageInvite: (data) -> $http.post "#{inviteUrl}/manage", data

    promote:      (data) -> $http.post "#{manageUrl}/promote", data
    demote:       (data) -> $http.post "#{manageUrl}/demote", data
    kick:         (data) -> $http.post "#{manageUrl}/kick", data
    donate:       (data) -> $http.post "#{manageUrl}/donate", data
    buff:         (data) -> $http.post "#{manageUrl}/buff", data

    tax:          (data) -> $http.post "#{manageUrl}/tax", data
    selftax:      (data) -> $http.post "#{baseURL}/player/manage/tax", data
]