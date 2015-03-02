angular.module 'IdleLands'
.controller 'PlayerGuild', [
  '$scope', '$mdDialog', 'CurrentGuild', 'CurrentGuildInvites', 'CurrentPlayer', 'API'
  ($scope, $mdDialog, CurrentGuild, CurrentGuildInvites, CurrentPlayer, API) ->

    $scope._ = window._

    $scope.initialize = ->
      $scope.guild = CurrentGuild.getGuild()
      $scope.guildInvites = CurrentGuildInvites.getGuildInvites()
      $scope.guildHallMap = encodeURIComponent $scope.guild?.baseMapName

      player = CurrentPlayer.getPlayer()
      $scope.currentlyInGuild = player?.guild

      $scope.editable.guildTaxRate = $scope.guild?.taxPercent
      $scope.editable.selfTaxRate = player?.guildTax

      if $scope.currentlyInGuild
        $scope.setupGuildData()
        $scope.getDonationTiers()

    $scope.setupGuildData = ->
      members = _.sortBy $scope.guild.members, (member) -> member.name
      leader = _.filter members, (member) -> member.identifier is $scope.guild.leader
      admins = _.filter members, (member) -> member.identifier isnt $scope.guild.leader and member.isAdmin
      normal = _.reject members, (member) -> member.isAdmin
      invites = _.map ($scope.guild.invites), (inv) -> {identifier: inv, name: inv, isInvite: yes}

      $scope.orderedMembers = leader.concat(admins).concat(normal).concat invites

      myIdent = CurrentPlayer.getPlayer()?.identifier
      $scope.isLeader = myIdent is $scope.guild.leader
      $scope.isAdmin = $scope.isLeader or _.findWhere admins, {identifier: myIdent}

      $scope.goldTiers = $scope.getDonationTiers()
      $scope.buildings = _.keys $scope.guild.validBuildings

      $scope.flatCosts = _.reduce $scope.guild.validBases, ((prev, base) -> prev[base.name] = base; prev), {}

    $scope.hasBuilt = (building) ->
      _.contains $scope.guild.currentlyBuilt[$scope.guild.validBuildings[building].size], building

    $scope.canBuild = (cost) ->
      $scope.guild.gold.__current >= cost

    $scope.checkLeader = (member) -> member.identifier is $scope.guild.leader
    $scope.checkAdmin  = (member) -> member.isAdmin

    $scope.getDonationTiers = ->
      x = []
      cur = CurrentPlayer.getPlayer()?.gold.__current
      x.push Math.round i*10 while ((i = i*10 or 100) and cur /= 10) > 1000
      x

    $scope.iconForMember = (member) ->
      return 'fa-star' if member.identifier is $scope.guild.leader
      return 'fa-star-half-o' if member.isAdmin
      'fa-star-o'

    $scope.canKick = (member) ->
      currentPlayer = CurrentPlayer.getPlayer()
      myIdent = currentPlayer?.identifier
      return no if member.identifier is myIdent
      return no if myIdent isnt $scope.guild.leader and member.isAdmin
      return no if $scope.isInvited member
      return no if currentPlayer?.guildStatus <= 0

      yes

    $scope.canRescind = (member) ->
      currentPlayer = CurrentPlayer.getPlayer()
      return no unless $scope.isInvited member
      return no if currentPlayer?.guildStatus <= 0

      yes

    $scope.canModRank = (member) ->
      myIdent = CurrentPlayer.getPlayer()?.identifier
      member.identifier isnt myIdent

    $scope.isInvited = (member) ->
      _.contains $scope.guild.invites, member.name

    $scope.openProps = (building) ->
      $mdDialog.show
        controller: 'PropsController'
        templateUrl: 'buildingProps'
        locals:
          building: building
          guild: $scope.guild

    $scope.constructBuilding = (building) ->
      $mdDialog.show
        controller: 'ConstructController'
        templateUrl: 'construct'
        locals:
          building: building
          guild: $scope.guild

    $scope.getTooltipText = (member) ->
      left = right = ''

      left = 'Member'
      if $scope.checkLeader member  then left = 'Leader'
      if $scope.checkAdmin member   then left = 'Admin'
      if $scope.isInvited member    then left = 'Invited'

      right = if member._cache?.online then 'Online' else 'Offline'

      "#{left}, #{right}"

    $scope.editable =
      guildName: ''
      buffLevel: 1
      guildTaxRate: 0
      selfTaxRate: 0

    $scope.initialize()

    # Watches
    CurrentGuild.observe().then null, null, (val) ->
      $scope.guild = val
      if $scope.guild
        $scope.setupGuildData()
        $scope.getDonationTiers()
        $scope.editable.guildTaxRate = $scope.guild.taxPercent

    CurrentGuildInvites.observe().then null, null, (val) ->
      $scope.guildInvites = val

    CurrentPlayer.observe().then null, null, (val) ->
      $scope.currentlyInGuild = val?.guild
      $scope.getDonationTiers()
      $scope.editable.selfTaxRate = val?.guildTax

    # API calls
    $scope.createGuild = ->
      API.guild.create {guildName: $scope.editable.guildName}

    $scope.manageInvite = (guild, accept) ->
      API.guild.manageInvite {guildName: guild, accepted: accept}

    $scope.kickMember = (name) ->
      confirm = $mdDialog.confirm()
      .title 'Kick Member'
      .content "Are you sure you want to kick #{name}?"
      .ok 'Yes'
      .cancel 'No'

      $mdDialog.show(confirm).then ->
        API.guild.kick {memberName: name}

    $scope.rescindInvite = (invIdent) ->
      confirm = $mdDialog.confirm()
      .title 'Rescind Invite'
      .content "Are you sure you want to take an invite away from #{invIdent}?"
      .ok 'Yes'
      .cancel 'No'

      $mdDialog.show(confirm).then ->
        API.guild.rescind {invIdent: invIdent}

    $scope.promoteMember = (name) ->
      API.guild.promote {memberName: name}

    $scope.demoteMember = (name) ->
      API.guild.demote {memberName: name}

    $scope.inviteMember = ->
      API.guild.invite {invName: $scope.editable.newMember}
      .then ->
        $scope.editable.newMember = ''
      yes

    $scope.leaveGuild = ->
      confirm = $mdDialog.confirm()
      .title 'Leave Guild'
      .content 'Are you sure you want to leave your guild?'
      .ok 'Yes'
      .cancel 'No'

      $mdDialog.show(confirm).then ->
        API.guild.leave()

    $scope.disbandGuild = ->
      confirm = $mdDialog.confirm()
      .title 'Disband Guild'
      .content 'Are you sure you want to disband your guild?'
      .ok 'Yes'
      .cancel 'No'

      $mdDialog.show(confirm).then ->
        API.guild.disband()

    $scope.donateGold = (gold) ->
      API.guild.donate {gold: gold}

    $scope.updateGuildTax = ->
      API.guild.tax {taxPercent: $scope.editable.guildTaxRate}

    $scope.updateSelfTax = ->
      API.guild.selftax {taxPercent: $scope.editable.selfTaxRate}

    $scope.move = ->
      confirm = $mdDialog.confirm()
      .title 'Change Guild Base'
      .content "Are you sure you want to move to #{$scope.guild.base}? It will cost #{$scope.flatCosts[$scope.guild.base].costs.moveIn} gold."
      .ok 'Yes'
      .cancel 'No'

      $mdDialog.show(confirm).then ->
        API.guild.move {newLoc: $scope.guild.base}

    $scope.upgradeBuilding = (building) ->
      API.guild.upgrade {building}

]

angular.module 'IdleLands'
.controller 'PropsController', [
  '$scope', '$mdDialog', 'API', 'guild', 'building'
  ($scope, $mdDialog, API, guild, building) ->
    $scope._ = window._
    $scope.close = $mdDialog.hide
    $scope.building = building
    $scope.guild = guild
    $scope.props = guild.buildingProps[building] or {}
    $scope.editable =
      buffLevel: guild.buildingGlobals?.Academy?.maxBuffLevel

    $scope.loadBuffsIntoHash = ->
      $scope.buffs = {}

      _.each guild.buffs, (buff) ->
        $scope.buffs[buff.type] = buff

    $scope.buffTypes = [
      'Agility'
      'Constitution'
      'Dexterity'
      'Fortune'
      'Intelligence'
      'Luck'
      'Strength'
      'Wisdom'
    ]

    $scope.nameToIcon = (name) ->
      switch name
        when 'Strength'     then return 'fa-legal fa-rotate-90'
        when 'Agility'      then return 'fa-bicycle'
        when 'Constitution' then return 'fa-heart'
        when 'Dexterity'    then return 'fa-crosshairs'
        when 'Fortune'      then return 'icon-money'
        when 'Intelligence' then return 'fa-mortar-board'
        when 'Luck'         then return 'fa-moon-o'
        when 'Wisdom'       then return 'fa-book'

    $scope.save = ->
      _.each (_.keys $scope.props), (prop) ->
        API.guild.setProperty {building: building, property: prop, value: $scope.props[prop]}
      $scope.close()

    $scope.buyBuff = (type) ->
      API.guild.buff {type: type, tier: $scope.editable.buffLevel}

    $scope.loadBuffsIntoHash()
]

angular.module 'IdleLands'
.controller 'ConstructController', [
  '$scope', '$mdDialog', 'API', 'guild', 'building'
  ($scope, $mdDialog, API, guild, building) ->
    $scope.close = $mdDialog.hide
    $scope.building = building

    buildingSize = guild.validBuildings[building].size

    $scope.takenSlots = guild.currentlyBuilt[buildingSize]
    slotCount = guild._validSlots[buildingSize]

    $scope.takenSlots.length = slotCount

    $scope.save = ->
      API.guild.construct {slot: $scope.slot, building: building}
      $scope.close()
]