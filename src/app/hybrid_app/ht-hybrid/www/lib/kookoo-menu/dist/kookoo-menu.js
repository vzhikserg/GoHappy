'use strict';
/**
 *  roadmap:
 *      add menu logic for the kookoo menu
 *      define params
 *          Sub-Menu Nodes with action call
 *          Core Node States
 *          sads
 *
 *   States:
 *      no gps, no connection
 *      everything okey to Go
 *      Go -> Taxi
 *              -> Call a Taxi (uber menu)
 *          -> Bus
 *          -> City
 *          -> Travel
 *          -> Bike
 *          -> Help
 *          -> add Passenger
 *
 */
angular.module('kookoo.menu', [])

    /**
     *  Main Directive wrapping the menu nodes and the
     *  menu entry point
     */
    .directive('kookooMenu', function(){

        return {
            restrict: 'E',
            scope: {
                nodes: '&',
                settings: '&'
            },
            link: function($scope, $element, $attr){


                $scope.menuItems = $scope.nodes();
                $scope.settings = $scope.settings();




                // prepare menu items inject styling
                angular.forEach($scope.menuItems, function(menuItem, key){

                    $scope.menuItems[key].menuStyle = {
                        style: 'kookoo-'+menuItem.angle
                        };

                    $scope.menuItems[key].iconStyle = {
                        style: 'kookoo-'+menuItem.angle+'-neg'
                        };

                    $scope.menuItems[key].buttonStyle = {
                        style: 'transform3d: translate3d(0px, 90px, 0px)'
                    };

                });

                var angle = 120;
                var distance = 90;
                var startingAngle = 180+(-angle/2);
                var slice = angle/($scope.menuItems.length-1);

                TweenMax.globalTimeScale(0.8);


            },
            templateUrl: 'lib/kookoo-menu/dist/kookoo-menu.html',
            controller: ['$scope', '$rootScope','$state', function( $scope, $rootScope, $state ){

                   $scope.on = false;


                    this.openMenu = function(){
                        $rootScope.$broadcast('open.menu');
                    };

                    this.closeMenu = function()
                    {
                        $rootScope.$broadcast('close.menu');
                    };

                    this.getRootScope = function()
                    {
                      return $rootScope;
                    };

                    this.getState = function(){
                        return $state;
                    };

                    this.getScope = function(){
                        return $scope;
                    };

                    this.getMenuState = function(){
                        return $scope.on;
                    };
            }]
        };

    })

    .directive('kookooNode', function(){
      return {
            restrict: 'A',
            scope: true,
            require: '^kookooMenu',
            link: function($scope, $element, $attrs, $controller){

                var distance = 110;
                var delay =  0.001;
                var $bounce = $($element).children('.kookoo-menu-item-bounce');

                $scope.routeTo = function( target ){
                    $controller.getState().go(target);
                };

                /**
                 *  open menu
                 */
                $controller.getRootScope().$on('open.menu', function(){

                     TweenMax.to($element, 0.4,{
                         rotation: $controller.getScope().on ? 45:0,
                         ease:Quint.easeInOut,
                         force3D:true
                     });

                    TweenMax.fromTo($bounce,0.2,{
                        transformOrigin:"50% 50%"
                    },{
                        delay:delay,
                        scaleX:0.8,
                        scaleY:1.2,
                        force3D:false,
                        ease:Quad.easeInOut,
                        onComplete:function(){
                            $scope.$apply();
                            TweenMax.to($bounce,0.15,{
                                // scaleX:1.2,
                                scaleY:0.7,
                                force3D:false,
                                ease:Quad.easeInOut,
                                onComplete:function(){
                                    $scope.$apply();
                                    TweenMax.to($bounce,3,{
                                        // scaleX:1,
                                        scaleY:0.8,
                                        force3D:false,
                                        ease:Elastic.easeOut,
                                        easeParams:[1.1,0.12]
                                    })
                                }
                            })
                        }
                    });

                    TweenMax.to($($element).children(".kookoo-menu-item-button"),0.5,{
                        delay:delay,
                        y:distance,
                        force3D:true,
                        ease:Quint.easeInOut
                    });


                    $scope.$apply();

                });


                /**
                 *  close menu
                 */
                $controller.getRootScope().$on('close.menu', function(){

                    TweenMax.fromTo($bounce,0.2,{
                        transformOrigin:"50% 50%"
                    },{
                        delay:delay,
                        scaleX:1,
                        scaleY:0.8,
                        force3D:false,
                        ease:Quad.easeInOut,
                        onComplete:function(){
                            $scope.$apply();
                            TweenMax.to($bounce,0.15,{
                                // scaleX:1.2,
                                scaleY:1.2,
                                force3D:false,
                                ease:Quad.easeInOut,
                                onComplete:function(){
                                    $scope.$apply();
                                    TweenMax.to($bounce,3,{
                                        // scaleX:1,
                                        scaleY:1,
                                        force3D:false,
                                        ease:Elastic.easeOut,
                                        easeParams:[1.1,0.12]
                                    })
                                }
                            })
                        }
                    });


                    TweenMax.to($($element).children(".kookoo-menu-item-button"),0.3,{
                        delay:delay,
                        y:0,
                        force3D: "auto",
                        ease:Quint.easeIn
                    });



                });

          }
      };
    })

    /**
     *  toggle directive for opening the menu and closing
     */
    .directive('kookooToggle', function(){
        return {
            restrict: 'A',
            scope: true,
            require: '^kookooMenu',
            link: function($scope, $element, $attrs, $controller){

                $scope.settings = $scope.settings();


                if($scope.settings.clickable) {

                    $element.bind('mousedown', function () {

                        //TweenMax.to($element, 0.01, {scale: 0.45});

                        $scope.settings.text = $controller.getScope().on ?  'Stop' : 'Go';
                        $scope.settings.showZone = $controller.getScope().on ? true : false;
                        $controller.getScope().on = !$controller.getScope().on;
                        $controller.getScope().on ? $controller.openMenu() : $controller.closeMenu();


                        // trigger child rotation
                    });

                    $element.bind('mouseup', function () {
                        //TweenMax.to($element, 0.1, {scale: 1});
                       $scope.settings.text = $controller.getScope().on ?  'Stop' : 'Go';
                        $scope.settings.showZone = $controller.getScope().on ? true : false;
                    });



                    $element.bind('touchstart', function( event ){
                        $element.trigger('mousedown');
                        event.preventDefault();
                        event.stopPropagation();
                    });

                    $(document).on("touchend",function(){
                        $(document).trigger("mouseup");
                    });

                }
            }
        };
    });


/**
 *  Blau 25 153 153
 *  CMYK RED 0 90 70 0 (ef404a
 *
 *
 *
 */



