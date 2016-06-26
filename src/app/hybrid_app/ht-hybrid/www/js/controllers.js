angular.module('starter.controllers', [])

.controller('DashCtrl', function($scope) {

})

.controller('NoGoCtrl', function($scope){

  $scope.menuItems = [];
  $scope.buttonSettings = {
    text: 'NoGo',
    styleClass: 'kookoo-no-go-btn',
    clickable: false,
    warning: 'Sorry, we need to know where you are. <br/><strong>Press the Button</strong> to enable Location Services.',
    showWarning: true
  };

  $scope.getButtonSettings = function(){
    return $scope.buttonSettings;
  };


  $scope.getMenuItems = function(){
    return $scope.menuItems;
  };



})

.controller('HomeCtrl', function($scope){

  $scope.menuItems = [
    {icon: 'bicycle', angle: 90, target: 'app'},
    {text: 'TAXI', angle: 140, target: 'app'},
    {icon: 'car', angle: 190, target: 'app'},
    {icon: 'map-o', angle: 210, target: 'app'},
    {icon: 'user-plus', angle: 360, target: 'app'},
    {icon: 'minus', angle: 330, target: 'app', iconSize: 1},
    {icon: 'tag', angle: 280, target: 'app'}
  ];


  $scope.buttonSettings = {
    text: 'Go',
    styleClass: '',
    clickable: true,
    warning: '',
    showWarning: false
  };


  setTimeout(function(){
    $scope.buttonSettings.zone = true;
  }, 3000);


  $scope.getButtonSettings = function(){
    return $scope.buttonSettings;
  };


  $scope.getMenuItems = function(){
    return $scope.menuItems;
  };

})

.controller('ChatsCtrl', function($scope, Chats) {
  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //
  //$scope.$on('$ionicView.enter', function(e) {
  //});

  $scope.chats = Chats.all();
  $scope.remove = function(chat) {
    Chats.remove(chat);
  };
})

.controller('ChatDetailCtrl', function($scope, $stateParams, Chats) {
  $scope.chat = Chats.get($stateParams.chatId);
})

.controller('AccountCtrl', function($scope) {
  $scope.settings = {
    enableFriends: true
  };
});
