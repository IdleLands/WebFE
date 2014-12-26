angular.module 'IdleLands'
.factory 'ItemUtilities', ->

  equipmentStatArray = [
    {name: 'str', fa: 'fa-legal fa-rotate-90'}
    {name: 'dex', fa: 'fa-crosshairs'}
    {name: 'agi', fa: 'fa-bicycle'}
    {name: 'con', fa: 'fa-heart'}
    {name: 'int', fa: 'fa-mortar-board'}
    {name: 'wis', fa: 'fa-book'}
    {name: 'luck', fa: 'fa-moon-o'}
    {name: 'fire', fa: 'fa-fire'}
    {name: 'water', fa: 'icon-water'}
    {name: 'thunder', fa: 'fa-bolt'}
    {name: 'earth', fa: 'fa-leaf'}
    {name: 'ice', fa: 'icon-snow'}
  ]

  extendedEquipmentStatArray = equipmentStatArray.concat {name: 'sentimentality'},
    {name: 'piety'},
    {name: 'enchantLevel'},
    {name: 'shopSlot'},
    {name: 'overflowSlot'},
    {name: 'uid'},
    {name: '_calcScore'},
    {name: '_baseScore'}

  equipmentStatArray: equipmentStatArray

  extendedEquipmentStatArray: extendedEquipmentStatArray

  classToColor: (itemClass) ->
    switch itemClass
      when 'newbie'   then return 'bg-maroon'
      when 'basic'    then return 'bg-gray'
      when 'pro'      then return 'bg-purple'
      when 'idle'     then return 'bg-rainbow'
      when 'godly'    then return 'bg-black'
      when 'custom'   then return 'bg-blue'
      when 'guardian' then return 'bg-cyan'
      when 'extra'    then return 'bg-orange'
      when 'total'    then return 'bg-teal'
      when 'shop'     then return 'bg-darkblue'

  getExtraStats: (item) ->
    keys = _.filter (_.compact _.keys item), (key) -> _.isNumber item[key]

    _.each extendedEquipmentStatArray, (stat) ->
      keys = _.without keys, stat.name
      keys = _.without keys, "#{stat.name}Percent"

    keys = _.reject keys, (key) -> item[key] is 0

    _.map keys, (key) -> "#{key} (#{item[key]})"
    .join ', '