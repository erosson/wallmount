'use strict'

###*
 # @ngdoc directive
 # @name wallmountApp.directive:clock
 # @description
 # # clock
###
angular.module('wallmountApp').directive 'clock', ($interval, $location) ->
    restrict: 'EA'
    template: """
<div class="clock">
  <h1 style="font-size:160px">{{displayTime()}}</h1>
  <!--h4>{{now.format('dddd, MMMM Do YYYY')}}</h4-->
  <h4>{{now.format('dddd, MMMM Do')}}</h4>
</div>
"""
    link: (scope, element, attrs) ->
      do update = -> scope.now = window.moment()
      if $location.search().forcerabbit?
        # can also forcerabbit-off with `?forcerabbit=` (empty string)
        isRabbit = -> !!$location.search().forcerabbit
      else
        # first of the month, before 12pm
        isRabbit = (now=scope.now) -> now.date() == 1 and now.hour() < 12
      scope.displayTime = (now=scope.now) ->
        # blink between time and rabbit-rabbit
        if isRabbit(now) and now.second() % 2 != 0
          return 'RA:BB:IT'
        else
          return now.format 'HH:mm:ss'
      $interval update, 200
