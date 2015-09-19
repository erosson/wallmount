'use strict'

###*
 # @ngdoc directive
 # @name wallmountApp.directive:clock
 # @description
 # # clock
###
angular.module('wallmountApp').directive 'clock', ($interval) ->
    restrict: 'EA'
    template: """
<div class="clock">
  <h1>{{now.format('HH:mm:ss')}}</h1>
  <!--h4>{{now.format('dddd, MMMM Do YYYY')}}</h4-->
  <h4>{{now.format('dddd, MMMM Do')}}</h4>
</div>
"""
    link: (scope, element, attrs) ->
      do update = -> scope.now = window.moment()
      $interval update, 200
