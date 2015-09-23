'use strict'

describe 'Directive: clock', ->

  # load the directive's module
  beforeEach module 'wallmountApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<clock></clock>'
    element = $compile(element) scope
    #expect(element.text()).toBe 'this is the clock directive'
