angular.module 'IdleLands'
.controller 'PlayerMap', [
  '$scope', '$timeout', 'Player', 'CurrentMap', 'BaseURL'
  ($scope, $timeout, Player, CurrentMap, BaseURL) ->

    $scope.currentMap = {}

    # map variables
    sprite = null
    game = null
    mapName = null
    newMapName = null

    $scope.drawMap = ->
      return if _.isEmpty $scope.currentMap
      player = $scope.player

      newMapName = player.map if not newMapName

      if sprite
        sprite.x = (player.x*16)
        sprite.y = (player.y*16)
        game.camera.x = sprite.x
        game.camera.y = sprite.y

        if player.map isnt mapName
          newMapName = player.map
          mapName = player.map
          game.state.restart()

      phaserOpts =
        preload: ->
          #gah, github. whatever.
          @game.load.image 'tiles', "#{BaseURL}/img/tiles.png", 16, 16
          @game.load.spritesheet 'interactables', "#{BaseURL}/img/tiles.png", 16, 16
          @game.load.tilemap newMapName, null, $scope.currentMap.map, Phaser.Tilemap.TILED_JSON

        create: ->
          map = @game.add.tilemap newMapName
          map.addTilesetImage 'tiles', 'tiles'
          terrain = map.createLayer 'Terrain'
          terrain.resizeWorld()
          map.createLayer 'Blocking'

          for i in [1, 2, 12, 13, 14, 15, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 35]
            map.createFromObjects 'Interactables', i, 'interactables', i-1

          sprite = @game.add.sprite player.x*16, player.y*16, 'interactables', 12
          @game.camera.follow sprite

      return if (not player) or game
      $timeout ->
        return if game
        game = new Phaser.Game '100%', '100%', Phaser.CANVAS, 'map', phaserOpts
      , 0
      null

    $scope.$watch (-> CurrentMap.getMap()), (newVal, oldVal) ->
      return if newVal is oldVal
      $scope.currentMap = newVal

    $scope.$watch (-> Player.getPlayer()), (newVal, oldVal) ->
      return if newVal is oldVal and (not newVal or not oldVal)
      $scope.player = newVal
      $scope.drawMap()

]