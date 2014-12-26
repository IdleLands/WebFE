angular.module 'IdleLands'
.factory 'CurrentPets', [
  '$q'
  ($q) ->
    pets = null
    defer = $q.defer()

    observe: -> defer.promise
    getPets: -> pets
    setPets: (newPets) ->
      pets = newPets
      defer.notify pets
]