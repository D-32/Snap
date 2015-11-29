//
//  AppDelegate.m
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  //self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  ViewController *vc = [[ViewController alloc] init];
  self.window.rootViewController = vc;


  return YES;
}

@end
