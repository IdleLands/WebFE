(function() {
  angular.module('IdleLands', ['ngMaterial', 'angularMoment', 'ui.router', 'LocalStorageModule', 'xeditable']);

  angular.module('IdleLands').run([
    'editableThemes', function(editableThemes) {
      editableThemes["default"].cancelTpl = '<md-button class="xeditable-form-button md-theme-red" ng-click="$form.$cancel()">Cancel</md-button>';
      return editableThemes["default"].submitTpl = '<md-button class="xeditable-form-button md-theme-green" type="submit">Save</md-button>';
    }
  ]);

  angular.module('IdleLands').config(['$locationProvider', function($loc) {}]);

}).call(this);

(function() {
  angular.module('IdleLands').config([
    '$stateProvider', '$urlRouterProvider', '$httpProvider', function($sp, $urp, $httpProvider) {
      $httpProvider.interceptors.push('TokenInterceptor');
      $httpProvider.interceptors.push('ToastInterceptor');
      $httpProvider.interceptors.push('PlayerInterceptor');
      $httpProvider.interceptors.push('ReloginInterceptor');
      $urp.otherwise('/');
      return $sp.state('home', {
        url: '/',
        templateUrl: 'home',
        controller: 'Home'
      }).state('login', {
        url: '/login',
        templateUrl: 'login',
        controller: 'Login'
      }).state('player', {
        url: '/player',
        templateUrl: 'player',
        controller: 'Player'
      });
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').controller('Head', [
    '$scope', '$interval', 'TurnTaker', 'Player', function($scope, $interval, TurnTaker, Player) {
      $scope.player = null;
      $scope._player = Player;
      return $scope.$watch('_player.getPlayer()', function(newVal, oldVal) {
        if (newVal === oldVal) {
          return;
        }
        $scope.player = newVal;
        return TurnTaker.beginTakingTurns($scope.player);
      });
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').controller('Home', [
    '$scope', '$state', function($scope, $state) {
      return $state.go('player');
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').controller('Login', [
    '$scope', '$state', 'API', 'CredentialCache', function($scope, $state, API, CredentialCache) {
      var goToPlayerView;
      $scope.selectedIndex = 0;
      $scope.selectTab = function(tabIndex) {
        return $scope.selectedIndex = tabIndex;
      };
      $scope.login = {};
      $scope.register = {};
      $scope.advLogin = {};
      $scope.isSubmitting = false;
      $scope.nameToIdentifier = function(name) {
        return "web-fe#" + name;
      };
      goToPlayerView = function() {
        return $state.go('player');
      };
      $scope.doLogin = function() {
        var data;
        data = _.clone($scope.login);
        data.identifier = $scope.nameToIdentifier(data.name);
        return $scope.sendLogin(data);
      };
      $scope.doAdvancedLogin = function() {
        return $scope.sendLogin($scope.advLogin);
      };
      $scope.doRegister = function() {
        var data;
        $scope.isSubmitting = true;
        data = _.clone($scope.register);
        data.identifier = $scope.nameToIdentifier(data.name);
        return API.auth.register(data).then(function(res) {
          if (res.data.isSuccess) {
            CredentialCache.setCreds(data);
          }
          goToPlayerView();
          return $scope.isSubmitting = false;
        });
      };
      return $scope.sendLogin = function(data) {
        $scope.isSubmitting = true;
        return API.auth.login(data).then(function(res) {
          if (res.data.isSuccess) {
            CredentialCache.setCreds(data);
            goToPlayerView();
          }
          return $scope.isSubmitting = false;
        });
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').controller('Player', [
    '$scope', '$state', '$window', '$timeout', '$mdToast', 'API', 'Player', 'TurnTaker', 'CredentialCache', 'OptionsCache', function($scope, $state, $window, $timeout, $mdToast, API, Player, TurnTaker, CredentialCache, OptionsCache) {
      var initializing;
      if (!Player.getPlayer()) {
        CredentialCache.tryLogin().then((function() {
          if (!Player.getPlayer()) {
            $mdToast.show({
              template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
            });
            return $state.go('login');
          } else {
            return TurnTaker.beginTakingTurns(Player.getPlayer());
          }
        }), (function() {
          $mdToast.show({
            template: "<md-toast>You don't appear to be logged in! Redirecting you to the login page...</md-toast>"
          });
          return $state.go('login');
        }));
      }
      OptionsCache.load(['scrollback']);
      $scope.options = OptionsCache.getOpts();
      $scope.personalityToggle = {};
      $scope.strings = {
        keys: [],
        values: []
      };
      $scope._player = Player;
      $scope.xpPercent = 0;
      $scope.selectedIndex = 0;
      $scope.statisticsKeys = {};
      $scope._ = $window._;
      $scope.selectTab = function(tabIndex) {
        return $scope.selectedIndex = tabIndex;
      };
      $scope.calcXpPercent = function() {
        return $scope.xpPercent = ($scope.player.xp.__current / $scope.player.xp.maximum) * 100;
      };
      $scope.sortPlayerItems = function() {
        return $scope.playerItems = (_.sortBy($scope.getEquipmentAndTotals($scope.player.equipment), function(item) {
          return item.type;
        })).concat($scope.getOverflows());
      };
      initializing = true;
      $scope.loadPersonalities = function() {
        return _.each($scope.player.personalityStrings, function(personality) {
          return $scope.personalityToggle[personality] = true;
        });
      };
      $scope.setPersonality = function(personality, to) {
        var func, key, props;
        func = to ? 'add' : 'remove';
        key = to ? 'newPers' : 'oldPers';
        props = {};
        props[key] = personality;
        return API.personality[func](props);
      };
      $scope.classToColor = function(itemClass) {
        switch (itemClass) {
          case 'newbie':
            return 'bg-maroon';
          case 'basic':
            return 'bg-gray';
          case 'pro':
            return 'bg-purple';
          case 'idle':
            return 'bg-rainbow';
          case 'godly':
            return 'bg-black';
          case 'custom':
            return 'bg-blue';
          case 'extra':
            return 'bg-orange';
          case 'total':
            return 'bg-teal';
        }
      };
      $scope.equipmentStatArray = [
        {
          name: 'str',
          fa: 'fa-legal fa-rotate-90'
        }, {
          name: 'dex',
          fa: 'fa-crosshairs'
        }, {
          name: 'agi',
          fa: 'fa-bicycle'
        }, {
          name: 'con',
          fa: 'fa-heart'
        }, {
          name: 'int',
          fa: 'fa-mortar-board'
        }, {
          name: 'wis',
          fa: 'fa-book'
        }, {
          name: 'luck',
          fa: 'fa-moon-o'
        }, {
          name: 'fire',
          fa: 'fa-fire'
        }, {
          name: 'water',
          fa: 'icon-water'
        }, {
          name: 'thunder',
          fa: 'fa-bolt'
        }, {
          name: 'earth',
          fa: 'fa-leaf'
        }, {
          name: 'ice',
          fa: 'icon-snow'
        }
      ];
      $scope.eventTypeToIcon = {
        'item-mod': ['fa-legal', 'fa-magic fa-rotate-90'],
        'item-find': ['icon-feather'],
        'item-enchant': ['fa-magic'],
        'item-switcheroo': ['icon-magnet'],
        'profession': ['fa-child'],
        'explore': ['fa-globe'],
        'levelup': ['icon-universal-access'],
        'achievement': ['fa-shield'],
        'party': ['fa-users'],
        'exp': ['fa-support'],
        'gold': ['icon-money'],
        'guild': ['fa-network']
      };
      $scope.achievementTypeToIcon = {
        'class': ['fa-child'],
        'event': ['fa-info'],
        'combat': ['fa-legal', 'fa-magic fa-rotate-90'],
        'special': ['fa-gift'],
        'personality': ['fa-group'],
        'exploration': ['fa-compass'],
        'progress': ['fa-signal']
      };
      $scope.extendedEquipmentStatArray = $scope.equipmentStatArray.concat({
        name: 'sentimentality'
      }, {
        name: 'piety'
      }, {
        name: 'enchantLevel'
      }, {
        name: '_calcScore'
      }, {
        name: '_baseScore'
      });
      $scope.getExtraStats = function(item) {
        var keys;
        keys = _.filter(_.compact(_.keys(item)), function(key) {
          return _.isNumber(item[key]);
        });
        _.each($scope.extendedEquipmentStatArray, function(stat) {
          keys = _.without(keys, stat.name);
          return keys = _.without(keys, "" + stat.name + "Percent");
        });
        keys = _.reject(keys, function(key) {
          return item[key] === 0;
        });
        return _.map(keys, function(key) {
          return "" + key + " (" + item[key] + ")";
        }).join(', ');
      };
      $scope.getEquipmentAndTotals = function(items) {
        var test;
        test = _.reduce(items, function(prev, cur) {
          var key, val;
          for (key in cur) {
            val = cur[key];
            if (!(key in prev) && _.isNumber(val)) {
              prev[key] = 0;
            }
            if (_.isNumber(val)) {
              prev[key] += val;
            }
          }
          return prev;
        }, {
          name: 'Equipment Stat Totals',
          type: 'TOTAL',
          itemClass: 'total'
        });
        items.unshift(test);
        return items;
      };
      $scope.getOverflows = function() {
        var items, overflow;
        items = [];
        overflow = $scope.player.overflow;
        if (overflow) {
          _.each(overflow, function(item, index) {
            item.extraItemClass = 'extra';
            item.extraText = "SLOT " + index;
            return items.push(item);
          });
        }
        return items;
      };
      $scope.logout = function() {
        Player.setPlayer(null);
        CredentialCache.doLogout();
        API.auth.logout();
        return $state.go('login');
      };
      $scope.valueToColor = function(value) {
        if (value < 0) {
          return 'text-red';
        }
        if (value > 0) {
          return 'text-green';
        }
      };
      $scope.itemItemScore = function(item) {
        if (!item._baseScore || !item._calcScore) {
          return 0;
        }
        return parseInt((item._calcScore / item._baseScore) * 100);
      };
      $scope.playerItemScore = function(item) {
        if (!item._calcScore || !$scope.player._baseStats.itemFindRange) {
          return 0;
        }
        return parseInt((item._calcScore / $scope.player._baseStats.itemFindRange) * 100);
      };
      $scope.buildStringList = function() {
        $scope.strings.keys = _.keys($scope.player.messages);
        $scope.strings.values = _.values($scope.player.messages);
        return $scope.strings.keys.push('');
      };
      $scope.updateStrings = function() {
        var newVal, oldVal, propDiff;
        oldVal = $scope.player.messages || {};
        newVal = _.zipObject($scope.strings.keys, $scope.strings.values);
        propDiff = _.omit(newVal, function(v, k) {
          return oldVal[k] === v;
        });
        if (_.isEmpty(propDiff)) {
          return;
        }
        $scope.player.messages = newVal;
        _.each(_.keys(propDiff), function(key) {
          return API.strings.set({
            type: key,
            msg: propDiff[key]
          });
        });
        return $scope.buildStringList();
      };
      $scope.removeString = function(key, index) {
        return API.strings.remove({
          type: key
        }).then(function() {
          $scope.strings.keys = _.reject($scope.strings.keys, function(key, kI) {
            return index === kI;
          });
          $scope.strings.values = _.reject($scope.strings.values, function(key, kI) {
            return index === kI;
          });
          $scope.player.messages = _.omit($scope.player.messages, key);
          return $scope.buildStringList();
        });
      };
      $scope.getAllStatisticsInFamily = function(family) {
        var base;
        if (!$scope.player) {
          return;
        }
        base = _.omit($scope.player.statistics, function(value, key) {
          return key.indexOf(family) !== 0;
        });
        return $scope.statisticsKeys[family] = _.keys(base);
      };
      $scope.handleScrollback = function() {
        var classFunc, scrollback;
        classFunc = $scope.options.scrollback === 'true' ? 'removeClass' : 'addClass';
        return scrollback = (angular.element('.scrollback-toast'))[classFunc]('hidden');
      };
      $timeout($scope.handleScrollback, 3000);
      $scope.$watch('strings', function(newVal, oldVal) {
        if (newVal === oldVal) {
          return;
        }
        return $scope.updateStrings();
      }, true);
      $scope.$watchCollection('personalityToggle', function(newVal, oldVal) {
        var propDiff;
        if (initializing || newVal === oldVal || _.isEmpty(oldVal)) {
          return;
        }
        propDiff = _.omit(newVal, function(v, k) {
          return oldVal[k] === v;
        });
        return _.each(_.keys(propDiff), function(pers) {
          return $scope.setPersonality(pers, propDiff[pers]);
        });
      });
      $scope.$watch('options', function(newVal, oldVal) {
        if (newVal === oldVal) {
          return;
        }
        OptionsCache.saveAll();
        return $scope.handleScrollback();
      }, true);
      $scope.$watch('player.pushbulletApiKey', function(newVal, oldVal) {
        if (newVal === oldVal || initializing) {
          return;
        }
        return API.pushbullet.set({
          apiKey: newVal
        });
      });
      return $scope.$watch('_player.getPlayer()', function(newVal, oldVal) {
        if (newVal === oldVal) {
          return;
        }
        initializing = true;
        $scope.player = newVal;
        $window.scrollback.nick = newVal.name;
        $scope.calcXpPercent();
        $scope.sortPlayerItems();
        $scope.loadPersonalities();
        $scope.buildStringList();
        _.each(['calculated', 'combat self', 'event', 'explore', 'player'], $scope.getAllStatisticsInFamily);
        return initializing = false;
      });
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').filter('reverse', function() {
    return function(items) {
      return items != null ? items.slice().reverse() : void 0;
    };
  });

}).call(this);

(function() {
  angular.module('IdleLands').directive('statisticsTree', [
    '$parse', '$timeout', function($parse, $timeout) {
      return {
        restrict: 'E',
        templateUrl: 'statistics-template',
        scope: {
          stats: '=',
          root: '=',
          family: '='
        },
        link: function(scope) {
          var stripFamily;
          stripFamily = function(str, family) {
            return (str.substring(family.length)).trim();
          };
          return scope.$watch('stats', function(newVal, oldVal) {
            var sortedStats;
            if (newVal === oldVal) {
              return;
            }
            scope.orderedData = [];
            sortedStats = _.sortBy(scope.stats, function(stat) {
              return stat;
            });
            return _.each(sortedStats, function(stat) {
              var data, sortedKeys, stripName;
              stripName = stripFamily(stat, scope.family);
              if (!stripName) {
                return;
              }
              data = scope.root[stat];
              scope.orderedData.push({
                name: stripName,
                value: (_.isPlainObject(data) ? '' : data),
                alignment: 'left'
              });
              if (_.isPlainObject(data)) {
                sortedKeys = (_.keys(data)).sort();
                return _.each(sortedKeys, function(subkey) {
                  return scope.orderedData.push({
                    name: subkey,
                    value: data[subkey],
                    alignment: 'right'
                  });
                });
              }
            });
          });
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('PlayerInterceptor', [
    'Player', function(Player) {
      return {
        request: function(request) {
          var player, _ref;
          if (!request.data) {
            request.data = {};
          }
          player = Player.getPlayer();
          if (((_ref = request.data) != null ? _ref.token : void 0) && player) {
            request.data.identifier = player.identifier;
          }
          return request;
        },
        response: function(response) {
          if (response.data.player) {
            Player.setPlayer(response.data.player);
          }
          return response;
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('ReloginInterceptor', [
    'CredentialCache', '$injector', function(CredentialCache, $injector) {
      var shouldRelog;
      shouldRelog = function(responseData) {
        return responseData.message === 'Token validation failed.';
      };
      return {
        response: function(response) {
          var creds;
          if (shouldRelog(response.data)) {
            creds = CredentialCache.getCreds();
            if (creds.identifier && creds.password) {
              ($injector.get('API')).auth.login(creds);
            }
          }
          return response;
        }
      };
    }
  ]);

}).call(this);

(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('IdleLands').factory('ToastInterceptor', [
    '$injector', function($injector) {
      var badMessages, canShowMessage;
      badMessages = ['Turn taken.', 'Token validation failed.', 'You can only have one turn every 10 seconds!'];
      canShowMessage = function(response) {
        var msg;
        msg = response.data.message;
        return (!response.config.data.suppress) && msg && !(__indexOf.call(badMessages, msg) >= 0);
      };
      return {
        response: function(response) {
          if (canShowMessage(response)) {
            ($injector.get('$mdToast')).show({
              template: "<md-toast>" + response.data.message + "</md-toast>"
            });
          }
          return response;
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('TokenInterceptor', [
    'Token', function(Token) {
      return {
        request: function(config) {
          if (!config.data) {
            config.data = {};
          }
          config.data.token = Token.getToken();
          return config;
        },
        response: function(response) {
          if (response.data.token) {
            Token.setToken(response.data.token);
          }
          return response;
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('Action', [
    '$http', 'BaseURL', function($http, baseURL) {
      var url;
      url = "" + baseURL + "/player/action";
      return {
        turn: function(data) {
          return $http.post("" + url + "/turn", data);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('API', [
    'Authentication', 'Action', 'Personality', 'Pushbullet', 'Strings', function(Authentication, Action, Personality, Pushbullet, Strings) {
      return {
        auth: Authentication,
        action: Action,
        personality: Personality,
        pushbullet: Pushbullet,
        strings: Strings
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('Authentication', [
    '$http', 'BaseURL', function($http, baseURL) {
      var url;
      url = "" + baseURL + "/player/auth";
      return {
        login: function(data) {
          return $http.post("" + url + "/login", data);
        },
        logout: function(data) {
          return $http.post("" + url + "/logout", data);
        },
        register: function(data) {
          return $http.put("" + url + "/register", data);
        },
        changePassword: function(data) {
          return $http.patch("" + url + "/password", data);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('Personality', [
    '$http', 'BaseURL', function($http, baseURL) {
      var url;
      url = "" + baseURL + "/player/manage/personality";
      return {
        add: function(data) {
          return $http.put("" + url + "/add", data);
        },
        remove: function(data) {
          return $http.post("" + url + "/remove", data);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('Pushbullet', [
    '$http', 'BaseURL', function($http, baseURL) {
      var url;
      url = "" + baseURL + "/player/manage/pushbullet";
      return {
        set: function(data) {
          return $http.put("" + url + "/set", data);
        },
        remove: function(data) {
          return $http.post("" + url + "/remove", data);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('Strings', [
    '$http', 'BaseURL', function($http, baseURL) {
      var url;
      url = "" + baseURL + "/player/manage/string";
      return {
        set: function(data) {
          return $http.put("" + url + "/set", data);
        },
        remove: function(data) {
          return $http.post("" + url + "/remove", data);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('BaseURL', function() {
    return 'http://api.idle.land';
  });

}).call(this);

(function() {
  angular.module('IdleLands').factory('CredentialCache', [
    'localStorageService', 'Token', '$injector', '$q', function(localStorageService, Token, $injector, $q) {
      var cacheCreds, credentials;
      credentials = {};
      cacheCreds = function() {
        localStorageService.set('identifier', credentials.identifier);
        localStorageService.set('name', credentials.name);
        return localStorageService.set('password', credentials.password);
      };
      return {
        doLogout: function() {
          localStorageService.set('identifier', '');
          localStorageService.set('name', '');
          localStorageService.set('password', '');
          Token.setToken('');
          return credentials = {};
        },
        tryLogin: function() {
          var defer, identifier, password;
          defer = $q.defer();
          identifier = localStorageService.get('identifier');
          password = localStorageService.get('password');
          if (!identifier || !password) {
            defer.reject();
          } else {
            credentials = {
              identifier: identifier,
              password: password,
              suppress: true
            };
            ($injector.get('API')).auth.login(credentials).then(function() {
              Token.loadToken();
              return defer.resolve();
            });
          }
          return defer.promise;
        },
        getCreds: function() {
          return credentials;
        },
        setCreds: function(newCreds) {
          credentials = newCreds;
          if (credentials.remember) {
            return cacheCreds();
          }
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('OptionsCache', [
    'localStorageService', function(localStorageService) {
      var getOpts, load, options, saveAll, set;
      options = {};
      load = function(keys) {
        return _.each(keys, function(key) {
          return options[key] = localStorageService.get(key);
        });
      };
      saveAll = function() {
        return _.each(_.keys(options), function(option) {
          return localStorageService.set(option, options[option]);
        });
      };
      set = function(key, val) {
        options[key] = val;
        return localStorageService.set(key, val);
      };
      getOpts = function() {
        return options;
      };
      return {
        load: load,
        saveAll: saveAll,
        set: set,
        getOpts: getOpts
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('Player', function() {
    var player;
    player = null;
    return {
      getPlayer: function() {
        return player;
      },
      setPlayer: function(newPlayer) {
        return player = newPlayer;
      }
    };
  });

}).call(this);

(function() {
  angular.module('IdleLands').factory('Token', [
    'localStorageService', function(localStorageService) {
      var token;
      token = null;
      return {
        loadToken: function() {
          if (token) {
            return;
          }
          return token = localStorageService.get('token');
        },
        getToken: function() {
          return token;
        },
        setToken: function(newToken) {
          token = newToken;
          return localStorageService.set('token', token);
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('IdleLands').factory('TurnTaker', [
    '$interval', 'API', function($interval, API) {
      var turnInterval;
      turnInterval = null;
      return {
        beginTakingTurns: function(player) {
          if (!player) {
            $interval.cancel(turnInterval);
            return;
          }
          if (turnInterval) {
            return;
          }
          API.action.turn({
            identifier: player.identifier
          });
          return turnInterval = $interval(function() {
            return API.action.turn({
              identifier: player.identifier
            });
          }, 10100);
        }
      };
    }
  ]);

}).call(this);
