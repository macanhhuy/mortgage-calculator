'use strict';

var app = angular.module('seedApp', ['slider', 'ui.bootstrap'])
  .config(['$routeProvider', function($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html'
        // controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  }]);
