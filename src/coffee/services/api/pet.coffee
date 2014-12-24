angular.module 'IdleLands'
.factory 'Pet', [
  '$http', 'BaseURL',
  ($http, baseURL) ->

    url = "#{baseURL}/pet"

    buyPet:     (data) -> $http.put   "#{url}/buy", data
    upgradePet: (data) -> $http.post  "#{url}/upgrade", data
    feedPet:    (data) -> $http.put   "#{url}/feed", data
    takeGold:   (data) -> $http.post  "#{url}/takeGold", data
    changeClass:(data) -> $http.patch "#{url}/class", data
    setSmart:   (data) -> $http.put   "#{url}/smart", data
    swapToPet:  (data) -> $http.patch "#{url}/swap", data
    giveItem:   (data) -> $http.put   "#{url}/inventory/give", data
    takeItem:   (data) -> $http.post  "#{url}/inventory/take", data
    sellItem:   (data) -> $http.patch "#{url}/inventory/sell", data
    equipItem:  (data) -> $http.put   "#{url}/inventory/equip", data
    unequipItem:(data) -> $http.post  "#{url}/inventory/unequip", data
]