'use strict'

describe 'Directive: weather', ->

  # load the directive's module
  beforeEach module 'wallmountApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<weather></weather>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the weather directive'
