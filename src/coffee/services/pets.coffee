angular.module 'IdleLands'
.factory 'CurrentPets', ->
  pets = null

  getPets: -> pets
  setPets: (newPets) -> pets = newPets