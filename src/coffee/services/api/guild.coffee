angular.module 'IdleLands'
.factory 'Guild', [
  '$http', 'BaseURL',
  ($http, baseURL) ->
  
    url = "#{baseURL}/guild"
    inviteUrl = "#{url}/invite"
    manageUrl = "#{url}/manage"
    buildUrl  = "#{url}/building"

    move:         (data) -> $http.put "#{url}/move", data
    
    create:       (data) -> $http.put  "#{url}/create", data
    leave:        (data) -> $http.post "#{url}/leave", data
    disband:      (data) -> $http.put  "#{url}/disband", data

    invite:       (data) -> $http.put  "#{inviteUrl}/player", data
    manageInvite: (data) -> $http.post "#{inviteUrl}/manage", data
    rescind:      (data) -> $http.post "#{inviteUrl}/player/rescind", data

    promote:      (data) -> $http.post "#{manageUrl}/promote", data
    demote:       (data) -> $http.post "#{manageUrl}/demote", data
    kick:         (data) -> $http.post "#{manageUrl}/kick", data
    donate:       (data) -> $http.post "#{manageUrl}/donate", data
    buff:         (data) -> $http.post "#{manageUrl}/buff", data

    tax:          (data) -> $http.post "#{manageUrl}/tax", data
    selftax:      (data) -> $http.post "#{baseURL}/player/manage/tax", data

    construct:    (data) -> $http.put   "#{buildUrl}/construct", data
    setProperty:  (data) -> $http.patch "#{buildUrl}/setProperty", data
    upgrade:      (data) -> $http.post  "#{buildUrl}/upgrade", data
]