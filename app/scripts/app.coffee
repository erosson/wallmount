'use strict'

###*
 # @ngdoc overview
 # @name wallmountApp
 # @description
 # # wallmountApp
 #
 # Main module of the application.
###
angular
  .module 'wallmountApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
        controllerAs: 'about'
      .otherwise
        redirectTo: '/'

# https://github.com/gr2m/appcache-nanny
# autoreload on deploy
angular.module('wallmountApp').run ->
  appCacheNanny = window.appCacheNanny
  # this is the default, let's just make it explicit
  appCacheNanny.start checkInterval: 30000
  appCacheNanny.on 'updateready', ->
    location.reload()
