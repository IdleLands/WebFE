angular.module 'IdleLands'
.factory 'Pet', ->
  pet = null

  getPet: -> pet
  setPet: (newPet) -> pet = newPet