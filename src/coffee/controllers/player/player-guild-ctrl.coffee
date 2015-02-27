angular.module 'IdleLands'
.controller 'PlayerGuild', [
  '$scope', 'CurrentGuild', 'CurrentGuildInvites', 'CurrentPlayer', 'API'
  ($scope, CurrentGuild, CurrentGuildInvites, CurrentPlayer, API) ->

    $scope.initialize = ->
      $scope.guild = CurrentGuild.getGuild()
      $scope.guildInvites = CurrentGuildInvites.getGuildInvites()

      player = CurrentPlayer.getPlayer()
      $scope.currentlyInGuild = player?.guild

      if $scope.currentlyInGuild
        $scope.setupGuildData()
        $scope.loadBuffsIntoHash()
        $scope.getDonationTiers()

    $scope.setupGuildData = ->
      members = _.sortBy $scope.guild.members, (member) -> member.name
      leader = _.filter members, (member) -> member.identifier is $scope.guild.leader
      admins = _.filter members, (member) -> member.identifier isnt $scope.guild.leader and member.isAdmin
      normal = _.reject members, (member) -> member.isAdmin
      invites = _.map ($scope.guild.invites), (inv) -> {identifier: inv, name: inv}

      $scope.orderedMembers = leader.concat(admins).concat(normal).concat invites

      myIdent = CurrentPlayer.getPlayer()?.identifier
      $scope.isLeader = myIdent is $scope.guild.leader
      $scope.isAdmin = $scope.isLeader or _.findWhere admins, {identifier: myIdent}

      $scope.goldTiers = $scope.getDonationTiers()

    $scope.checkLeader = (member) -> member.identifier is $scope.guild.leader
    $scope.checkAdmin  = (member) -> member.isAdmin

    $scope.loadBuffsIntoHash = ->
      $scope.buffs = {}

      _.each $scope.guild.buffs, (buff) ->
        $scope.buffs[buff.type] = buff

    $scope.getDonationTiers = ->
      x = []
      cur = CurrentPlayer.getPlayer()?.gold.__current
      x.push Math.round i*10 while ((i = i*10 or 100) and cur /= 10) > 1000
      x

    $scope.iconForMember = (member) ->
      return 'fa-star' if member.identifier is $scope.guild.leader
      return 'fa-star-half-o' if member.isAdmin
      'fa-star-o'

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

    $scope.canKick = (member) ->
      currentPlayer = CurrentPlayer.getPlayer()
      myIdent = currentPlayer?.identifier
      return no if member.identifier is myIdent
      return no if myIdent isnt $scope.guild.leader and member.isAdmin
      return no if $scope.isInvited member
      return no if currentPlayer?.guildStatus <= 0

      yes

    $scope.canModRank = (member) ->
      myIdent = CurrentPlayer.getPlayer()?.identifier
      member.identifier isnt myIdent

    $scope.isInvited = (member) ->
      _.contains $scope.guild.invites, member.name

    $scope.getTooltipText = (member) ->
      left = right = ''

      left = 'Member'
      if $scope.checkLeader member  then left = 'Leader'
      if $scope.checkAdmin member   then left = 'Admin'
      if $scope.isInvited member    then left = 'Invited'

      right = if member._cache?.online then 'Online' else 'Offline'

      "#{left}, #{right}"

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
        $scope.loadBuffsIntoHash()
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

    $scope.buyBuff = (type) ->
      API.guild.buff {type: type, tier: $scope.editable.buffLevel}

    $scope.kickMember = (name) ->
      API.guild.kick {memberName: name}

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
      API.guild.leave()

    $scope.disbandGuild = ->
      API.guild.disband()

    $scope.donateGold = (gold) ->
      API.guild.donate {gold: gold}

    $scope.updateGuildTax = ->
      API.guild.tax {taxPercent: $scope.editable.guildTaxRate}

    $scope.updateSelfTax = ->
      API.guild.selftax {taxPercent: $scope.editable.selfTaxRate}

]