angular.module 'IdleLands'
.factory 'ToastInterceptor', ['$injector', ($injector) ->

  badMessages = [
    'Turn taken.'
    'Token validation failed.'
    'You can only have one turn every 10 seconds!'
  ]

  canShowMessage = (msg) ->
    msg and not (msg in badMessages)

  response: (response) ->
    ($injector.get '$mdToast').show template: "<md-toast>#{response.data.message}</md-toast>" if canShowMessage response.data.message
    response
]