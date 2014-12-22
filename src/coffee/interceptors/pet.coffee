angular.module 'IdleLands'
.factory 'PetInterceptor', [
  'Pet',
  (Pet) ->
    response: (response) ->
      Pet.setPet response.data.pet if response.data.pet
      response
]