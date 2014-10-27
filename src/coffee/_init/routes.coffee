angular.module 'IdleLands'
  .config [
    '$stateProvider', '$urlRouterProvider', '$httpProvider',
    ($sp, $urp, $httpProvider) ->

      $httpProvider.interceptors.push 'TokenInterceptor'
      $httpProvider.interceptors.push 'ToastInterceptor'
      $httpProvider.interceptors.push 'PlayerInterceptor'
      $httpProvider.interceptors.push 'ReloginInterceptor'

      $urp.otherwise '/'

      $sp
        .state 'home',
          url: '/'
          templateUrl: 'home'
          controller: 'Home'

        .state 'login',
          url: '/login'
          templateUrl: 'login'
          controller: 'Login'

        .state 'player',
          url: '/player'
          templateUrl: 'player'
          controller: 'Player'
  ]