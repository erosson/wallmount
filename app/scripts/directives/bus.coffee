# This module is deliberately undocumented, because I don't need you folks figuring out where I live or even what transit system I'm using.
# Anything that can point you back to that is passed in via ?busconfig=
'use strict'

class BusStopTime
  constructor: (@line, @arrivalTime, @departureTime, @config) ->
  untilArrivalStr: ->
    @arrivalTime.fromNow()
  untilArrivalMins: (now) ->
    diff = @untilArrival now
    return diff.asMinutes()
  untilArrival: (now=moment()) ->
    moment.duration @arrivalTime.diff now
  isArrivingTooSoon: ->
    @untilArrival().asMilliseconds() < @config.tooSoon.asMilliseconds()
  @parse: (rawstop, config) ->
    rawbus = rawstop.MonitoredVehicleJourney
    now = moment now # accept js dates
    return new BusStopTime rawbus.PublishedLineName,
      moment(rawbus.MonitoredCall.AimedArrivalTime),
      moment(rawbus.MonitoredCall.AimedDepartureTime),
      config

###*
 # @ngdoc directive
 # @name wallmountApp.directive:bus
 # @description
 # # bus
###
angular.module('wallmountApp').directive 'bus', ($timeout, $interval, $http, $location) ->
  restrict: 'EA'
  template: """
<h4 ng-repeat="route in routes">
  {{route.config.label}}:
  <span ng-if="!(route.stops && route.stops.length > 0)">
    <i>NOPE.</i>
  </span>
  <span ng-if="route.stops && route.stops.length > 0">
    <span ng-repeat="stop in route.stops" ng-class="{arrivingTooSoon:stop.isArrivingTooSoon(), alreadyPassed:stop.untilArrivalMins() <= 0}">
      <!-- {{stop.untilArrivalStr()}}<span ng-if="!$last">,</span> -->
      {{stop.untilArrivalMins() | number:0}}<span ng-if="!$last">,</span>
    </span> minutes
  </span>
</h4>
"""
  link: (scope, element, attrs) ->
    CONFIG = $location.search().busconfig
    if !CONFIG
      console.log 'no bus route config specified. Not showing bus routes.'
      return
    CONFIG = JSON.parse CONFIG
    console.log JSON.stringify CONFIG
    console.log encodeURIComponent JSON.stringify CONFIG
    for route in CONFIG.routes
      route.tooSoon = moment.duration route.tooSoon, 'ms'
      if route.match?
        route.match = new RegExp route.match

    refreshOne = (route) ->
      refreshSelf = -> refreshOne route
      params =
        api_key: CONFIG.apikey
        agency: route.config.agency
        stopcode: route.config.stopcode
        format: 'json'
      $http.get "#{CONFIG.baseurl}?#{$.param params}"
      .then (res) ->
        stops = (BusStopTime.parse(stop, route.config) for stop in res.data.ServiceDelivery.StopMonitoringDelivery.MonitoredStopVisit)
        matcher = route.config.match
        route.stops = (stop for stop in stops when (!matcher?) or (matcher.test stop.line))
        $timeout refreshSelf, INTERVAL
      , (err) ->
        $timeout refreshSelf, INTERVAL

    INTERVAL = 5 * 60 * 1000
    scope.routes = (config:route, stops:null for route in CONFIG.routes)
    for route in scope.routes
      refreshOne route
