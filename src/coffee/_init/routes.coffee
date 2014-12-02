angular.module 'IdleLands'
  .config [
    '$stateProvider', '$urlRouterProvider', '$httpProvider',
    ($sp, $urp, $httpProvider) ->

      $httpProvider.interceptors.push 'TokenInterceptor'
      $httpProvider.interceptors.push 'ToastInterceptor'
      $httpProvider.interceptors.push 'PlayerInterceptor'
      $httpProvider.interceptors.push 'ReloginInterceptor'

      $urp.otherwise '/'

      $urp.when '/player', '/player/overview'

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

        .state 'player.overview',
          url: '/overview'
          data:
            selectedTab: 0
          views:
            'overview':
              templateUrl: 'player-overview'
              controller: 'PlayerOverview'

        .state 'player.map',
          url: '/map'
          data:
            selectedTab: 1
          views:
            'map':
              templateUrl: 'player-map'
              controller: 'PlayerMap'

        .state 'player.equipment',
          url: '/equipment'
          data:
            selectedTab: 2
          views:
            'equipment':
              templateUrl: 'player-equipment'
              controller: 'PlayerEquipment'

        .state 'player.battle',
          url: '/battle'
          data:
            selectedTab: 3
          views:
            'battle':
              templateUrl: 'player-battle'
              controller: 'PlayerBattle'

        .state 'player.achievements',
          url: '/achievements'
          data:
            selectedTab: 4
          views:
            'achievements':
              templateUrl: 'player-achievements'
              controller: 'PlayerAchievements'

        .state 'player.statistics',
          url: '/statistics'
          data:
            selectedTab: 5
          views:
            'statistics':
              templateUrl: 'player-statistics'
              controller: 'PlayerStatistics'

        .state 'player.options',
          url: '/options'
          data:
            selectedTab: 6
          views:
            'options':
              templateUrl: 'player-options'
              controller: 'PlayerOptions'
  ]