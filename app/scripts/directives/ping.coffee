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
  <h1>Ping: {{ping.ms|number:0}}</h1>
  <h6>Max: {{ping.max|number:0}}ms</h6>
  <canvas id="pingchart" width="400" height="200"></canvas>
</div>
"""
    link: (scope, element, attrs) ->
      maxElements = 60
      chartLabels = []
      chartPoints = []
      scope.ping = {list:[]}
      for i in [0...maxElements]
        chartLabels.push ''
        chartPoints.push 0
        scope.ping.list.push 0
      chartData =
        labels: chartLabels
        datasets: [
          data:chartPoints
        ]
      chart = new window.Chart($("#pingchart").get(0).getContext("2d")).Line chartData,
        # animation lags my poor old tablet
        animation: false
        # fixed scale makes it easy to see at a glance how we're lagging
        scaleStartValue:0, showScale: true
        scaleOverride:true, scaleSteps:5, scaleStepWidth: 200
        # other options
        showScaleGridLines:false
        pointDot: true, pointDotRadius:2
      now = ->
        # performance?.now ? Date.now # NOPE illegal invocation
        if performance?.now
          performance.now()
        else
          Date.now()
      push = (ms, next) ->
        scope.ping.ms = ms
        scope.ping.list.push scope.ping.ms
        scope.ping.list.shift()
        scope.ping.max = Math.max.apply null, scope.ping.list
        chart.addData [ms], ''
        chart.removeData()
        # wait a bit before the next ping - gives the chart a chance to update on a slow device
        $timeout next, interval/2
        
      interval = 2000
      refresh = ->
        start = now()
        $http.head '/', timeout:10000
        .then ->
          end = now()
          push end - start, ->
            $timeout refresh, interval
        , ->
          push 99999, ->
            $timeout refresh, interval
      # pinging during page load always lags, so wait a second
      $timeout refresh, interval
      # timeout instead of refresh - no need to have multiple pings out at once during lag
      #$interval refresh, 1000
