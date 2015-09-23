'use strict'

###*
 # @ngdoc directive
 # @name wallmountApp.directive:ping
 # @description
 # # ping
###
angular.module('wallmountApp').directive 'ping', ($interval, $timeout, $http) ->
    restrict: 'EA'
    template: """
<div>
  <h1>Ping: {{ping.ms|number:0}}ms</h1>
  <h3>1min max: {{ping.max|number:0}}ms</h3>
  <small>({{ping.list.length}} samples)</small> 
</div>
"""
    link: (scope, element, attrs) ->
      now = ->
        # performance?.now ? Date.now # NOPE illegal invocation
        if performance?.now
          performance.now()
        else
          Date.now()
      scope.ping = {list:[]}
      push = (ms) ->
        scope.ping.ms = ms
        scope.ping.list.push scope.ping.ms
        if scope.ping.list.length > 60
          scope.ping.list.shift()
        scope.ping.max = Math.max.apply null, scope.ping.list
        
      refresh = ->
        start = now()
        $http.get '/'
        .then ->
          end = now()
          push end - start
          $timeout refresh, 1000
        , ->
          push 99999
          $timeout refresh, 1000
      # pinging during page load always lags, so wait a second
      $timeout refresh, 1000
      # timeout instead of refresh - no need to have multiple pings out at once during lag
      #$interval refresh, 1000
