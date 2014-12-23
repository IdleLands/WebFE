angular.module 'IdleLands'
.factory 'CurrentPet', ->
  pet = null

  getPet: -> pet
  setPet: (newPet) -> pet = newPet