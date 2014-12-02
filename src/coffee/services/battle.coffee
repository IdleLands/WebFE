angular.module 'IdleLands'
.factory 'CurrentBattle', [
  ->

    battle = null

    getBattle: -> battle
    setBattle: (newBattle) -> battle = newBattle
]