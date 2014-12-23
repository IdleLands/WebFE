angular.module 'IdleLands'
.factory 'PetInterceptor', [
  'CurrentPet',
  (CurrentPet) ->
    response: (response) ->
      CurrentPet.setPet response.data.pet if response.data.pet
      response
]