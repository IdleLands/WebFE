angular.module 'IdleLands'
.config [
  '$mdThemingProvider'
  ($mdThemingProvider) ->

    $mdThemingProvider.alwaysWatchTheme yes

    $mdThemingProvider.definePalette 'white',
      '50':   'ffffff'
      '100':  'ffffff'
      '200':  'ffffff'
      '300':  'ffffff'
      '400':  'ffffff'
      '500':  'ffffff'
      '600':  'ffffff'
      '700':  'ffffff'
      '800':  'ffffff'
      '900':  'ffffff'
      'A100': 'ffffff'
      'A200': 'ffffff'
      'A400': 'ffffff'
      'A700': 'ffffff'
      contrastDefaultColor: 'dark'

    $mdThemingProvider.definePalette 'black',
      '50':   '000000'
      '100':  '000000'
      '200':  '000000'
      '300':  '000000'
      '400':  '000000'
      '500':  '000000'
      '600':  '000000'
      '700':  '000000'
      '800':  '000000'
      '900':  '000000'
      'A100': '000000'
      'A200': '000000'
      'A400': '000000'
      'A700': '000000'
      contrastDefaultColor: 'light'

    themes = [
      {name: 'bright',          primary: 'yellow',      accent: 'lime',         warn: 'grey',     background: 'lime' }
      {name: 'default',         primary: 'indigo',      accent: 'deep-purple',  warn: 'red',      background: 'grey'  }
      {name: 'dim-ocean',       primary: 'blue',        accent: 'indigo',       warn: 'teal',     background: 'blue-grey' }
      {name: 'earth',           primary: 'brown',       accent: 'deep-orange',  warn: 'amber',    background: 'orange' }
      {name: 'green-machine',   primary: 'green',       accent: 'blue',         warn: 'orange',   background: 'grey'  }
      {name: 'halloween',       primary: 'orange',      accent: 'deep-orange',  warn: 'brown',    background: 'brown' }
      {name: 'majestic',        primary: 'deep-purple', accent: 'purple',       warn: 'amber',    background: 'grey'  }
      {name: 'monochrome',      primary: 'black',       accent: 'white',        warn: 'black',    background: 'white'  }
      {name: 'ocean',           primary: 'blue',        accent: 'indigo',       warn: 'teal',     background: 'cyan' }
      {name: 'simple',          primary: 'white',       accent: 'black',        warn: 'white',    background: 'white'  }
    ]

    _.each themes, (theme) ->
      $mdThemingProvider
        .theme theme.name
        .primaryPalette theme.primary
        .accentPalette theme.accent
        .warnPalette theme.warn
        .backgroundPalette theme.background
]