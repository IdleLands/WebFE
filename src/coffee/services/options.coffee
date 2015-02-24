angular.module 'IdleLands'
.factory 'OptionsCache', [
  'localStorageService',
  (localStorageService) ->
    options = {}

    loadOne = (key) ->
      options[key] = localStorageService.get key

    load = (keys) ->
      _.each keys, (key) ->
        options[key] = localStorageService.get key

    saveAll = ->
      _.each (_.keys options), (option) ->
        localStorageService.set option, options[option]

    set = (key, val) ->
      options[key] = val
      localStorageService.set key, val

    getOpts = -> options

    loadOne: loadOne
    load: load
    saveAll: saveAll
    set: set
    getOpts: getOpts
]