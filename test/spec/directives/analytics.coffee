'use strict'

describe 'Directive: analytics', ->

  # load the directive's module
  beforeEach module 'wallmountApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  xit 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<analytics></analytics>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the analytics directive'
