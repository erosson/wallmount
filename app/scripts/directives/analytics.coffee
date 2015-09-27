'use strict'
# See Google Analytics data.
# Powered by a proxy server, Analytics Superproxy, running at https://swarmsim-wallboard.appspot.com/admin
# Setup instructions: https://github.com/googleanalytics/google-analytics-super-proxy#readme
# The config file with my app's secret keys has not been checked into source control. (Just create a new one later if it gets lost.)
# Also need to do something like this: https://github.com/erajasekar/google-analytics-super-proxy/commit/26a0fb907c268ccd70b5b16bcfdb1e610a794fee?diff=unified

###*
 # @ngdoc directive
 # @name wallmountApp.directive:analytics
 # @description
 # # analytics
###
angular.module('wallmountApp').directive 'analytics', ($timeout, $http) ->
    restrict: 'EA'
    template: """
<div ng-if="!loaded">
Loading analytics...
</div>
<div ng-if="loaded">
<h3>{{activeUsers|number}} <small>Swarmsim players online</small></h3>
</div>
"""
    link: (scope, element, attrs) ->
      # superproxy 
      do refresh = ->
        #console.log 'analytics start loading'
        # this makes swarmsim's current-active-users public to the world. I'm okay with that.
        $http.get 'https://swarmsim-wallboard.appspot.com/query?id=ahRzfnN3YXJtc2ltLXdhbGxib2FyZHIVCxIIQXBpUXVlcnkYgICAgICAgAoM'
        .then (res) ->
          scope.loaded = true
          users = res.data.rows[0][0]
          console.log 'analytics response', arguments, users
          scope.activeUsers = users
          $timeout refresh, 60000
        , ->
          $timeout refresh, 60000
