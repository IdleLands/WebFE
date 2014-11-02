angular.module 'IdleLands'
  .filter 'reverse', ->
    (items) ->
      items?.slice().reverse()