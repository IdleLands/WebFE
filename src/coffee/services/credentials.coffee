angular.module 'IdleLands'
.factory 'CredentialCache', ->
  credentials = {}

  getCreds: -> credentials
  setCreds: (newCreds) -> credentials = newCreds