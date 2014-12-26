angular.module 'IdleLands'
.factory 'CurrentPet', [
  '$q'
  ($q) ->
    pet = null
    defer = $q.defer()

    observe: -> defer.promise
    getPet: -> pet
    setPet: (newPet) ->
      pet = newPet
      defer.notify pet
]