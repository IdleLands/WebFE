angular.module 'IdleLands'
.controller 'PlayerMap', [
  '$scope', '$timeout', 'CurrentPlayer', 'CurrentMap', 'BaseURL'
  ($scope, $timeout, Player, CurrentMap, BaseURL) ->

    $scope.currentMap = {}

    # map variables
    sprite = null
    game = null
    mapName = null
    newMapName = null
    text = null
    objectGroup = null
    itemText = ''

    handleObjects = ->
      _.each objectGroup.children, (child) ->

        child.inputEnabled = yes

        child.events.onInputOver.add ->
          itemText = ''
          itemText = "#{child.realtype}: #{child.name}" if child.realtype and child.realtype isnt 'Door'

          itemText += "\n\"#{child.flavorText}\"" if child.flavorText

          requires = no
          requirementText = '\nRequirements\n-------------------'
          if child.requireAchievement then requirementText += "\nAchievement: #{child.requireAchievement}";requires=yes
          if child.requireBoss        then requirementText += "\nBoss Kill: #{child.requireBoss}";requires=yes
          if child.requireClass       then requirementText += "\nClass: #{child.requireClass}";requires=yes
          if child.requireCollectible then requirementText += "\nCollectible: #{child.requireCollectible}";requires=yes
          if child.requireHoliday     then requirementText += "\nHoliday: #{child.requireHoliday}";requires=yes

          itemText = "#{itemText}\n#{requirementText}" if requires

        child.events.onInputOut.add ->
          itemText = ''

    hoverText = ->
      coordinates = ((game.camera.x+game.input.x)//16) + ', ' + ((game.camera.y+game.input.y)//16)
      "Hovering (#{coordinates})\n#{itemText}"

    textForPlayer = (player) ->
      "#{player.map} (#{player.mapRegion})\n#{player.x}, #{player.y}\n\n#{hoverText()}"

    $scope.drawMap = ->
      return if _.isEmpty $scope.currentMap
      player = $scope.player

      newMapName = player.map if not newMapName

      if text
        text.text = textForPlayer player

      if sprite
        sprite.x = (player.x*16)
        sprite.y = (player.y*16)
        game.camera.x = sprite.x
        game.camera.y = sprite.y

        if player.map isnt mapName
          newMapName = player.map
          mapName = player.map

      phaserOpts =
        preload: ->
          @game.load.image 'tiles', "#{BaseURL}/img/tiles.png", 16, 16
          @game.load.spritesheet 'interactables', "#{BaseURL}/img/tiles.png", 16, 16
          @game.load.tilemap newMapName, null, $scope.currentMap.map, Phaser.Tilemap.TILED_JSON

        create: ->
          map = @game.add.tilemap newMapName
          map.addTilesetImage 'tiles', 'tiles'
          terrain = map.createLayer 'Terrain'
          terrain.resizeWorld()
          map.createLayer 'Blocking'

          objectGroup = @game.add.group()

          for i in [1, 2, 12, 13, 14, 15, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 35]
            map.createFromObjects 'Interactables', i, 'interactables', i-1, yes, no, objectGroup

          handleObjects()

          sprite = @game.add.sprite player.x*16, player.y*16, 'interactables', 12
          @game.camera.follow sprite

          text = @game.add.text 10, 10, (textForPlayer player), {font: '15px Arial', fill: '#fff', stroke: '#000', strokeThickness: 3}
          text.fixedToCamera = yes

      return if (not player) or game
      $timeout ->
        return if game
        game = new Phaser.Game '100%', '100%', Phaser.CANVAS, 'map', phaserOpts
      , 0
      null

    $scope.initializeMap = ->
      $scope.currentMap = CurrentMap.getMap()
      _.each $scope.currentMap?.map?.layers[2].objects, (object) ->

        object.properties =
          realtype: object.type
          teleportX: parseInt object.properties.destx
          teleportY: parseInt object.properties.desty
          teleportMap:        object.properties.map
          teleportLocation:   object.properties.toLoc
          requireBoss:        object.properties.requireBoss
          requireCollectible: object.properties.requireCollectible
          requireAchievement: object.properties.requireAchievement
          requireClass:       object.properties.requireClass
          flavorText:         object.properties.flavorText
          requireHoliday:     object.properties.holiday

      game?.state.restart()

    CurrentMap.observe().then null, null, ->
      $scope.initializeMap()

    $scope.initializeMap()

    Player.observe().then null, null, ->
      $scope.drawMap()

    $scope.drawMap()

]