'use strict';

describe('Controller: MainCtrl', function() {

  // load the controller's module
  beforeEach(module('seedApp'));

  var MainCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function($controller) {
    scope = {};
    MainCtrl = $controller('MainCtrl', {
      $scope: scope
    });
  }));

  it('should attach an empty list to the scope', function() {
    expect(scope.var.data.length).toBe(0);
  });
});
