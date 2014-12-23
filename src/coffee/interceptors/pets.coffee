angular.module 'IdleLands'
.factory 'PetsInterceptor', [
  'CurrentPets',
  (CurrentPets) ->
    response: (response) ->
      CurrentPets.setPets response.data.pets if response.data.pets
      response
]