'use strict'

###*
 # @ngdoc directive
 # @name wallmountApp.directive:weather
 # @description
 # # weather
###
angular.module('wallmountApp').directive 'weather', ($interval, $location) ->
    restrict: 'EA'
    template: """
<div class="weather" ng-if="loading">
  <h4>Loading weather...</h4>
</div>
<div class="weather row container" ng-if="!loading">
  <!--h2><i ng-class="'icon-'+weather.code"></i></h2-->
  <div class="row">
    <div class="col-xs-6 col-sm-6" style="text-align:right"><img style="max-width:100%" ng-src="{{weather.image}}"></div>
    <div class="col-xs-6 col-sm-6" style="text-align:left">
      <h1>{{weather.temp}}&deg;{{weather.units.temp}}</h1>
      <div>{{weather.city}}{{region}}{{country}}</div>
    </div>
  </div>
  <div class="row">
    <div class="forecast" ng-repeat="forecast in weather.forecast">
      <div class="small">{{forecast.day}}</div>
      <div><img ng-src="{{forecast.thumbnail}}"></div>
      <div class="small">{{forecast.high}}&deg;</div>
      <div class="small">{{forecast.low}}&deg;</div>
    </div>
  </div>
</div>
"""
    link: (scope, element, attrs) ->
      # http://codepen.io/fleeting/pen/Idsaj
      scope.loading = true
      refresh = (location, woeid) ->
        $.simpleWeather
          location: location
          woeid: woeid
          unit: 'f'
          success: (weather) ->
            scope.loading = false
            scope.weather = weather
            scope.region = weather.region
            if scope.region
              scope.region = ", #{scope.region}"
            scope.country = ''
            if weather.country != 'United States'
              scope.country = ", #{weather.country}"
      setup = (loc) ->
        do load = -> refresh loc
        # refresh every 1 hour
        $interval load, 1000 * 60 * 60 * 1
      #setup 'Hell, Norway'
      if (loc=$location.search().loc)?
        setup loc
      else
        navigator.geolocation.getCurrentPosition (pos) ->
          setup "#{pos.coords.latitude},#{pos.coords.longitude}"

