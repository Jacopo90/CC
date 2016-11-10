//
//  ChameleonAppDelegate.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 10/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ChameleonAppDelegate.h"

@implementation ChameleonAppDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    window.backgroundColor = [UIColor whiteColor];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    TesterViewController * controller = [[TesterViewController alloc] initWithNibName: nil bundle: nil];
    controller.title = @"Initial Title";
    
    navController = [[UINavigationController alloc] initWithRootViewController: controller];
    navController.view.frame = window.bounds;
    navController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    navController.view.autoresizesSubviews = YES;
    
    [window addSubview: navController.view];
    
    [window makeKeyAndVisible];
}

@end
