//
//  ChameleonAppDelegate.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 10/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ChameleonAppDelegate.h"
//#import <MIACore/MIACore.h>

@implementation ChameleonAppDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    window.backgroundColor = [UIColor whiteColor];
//    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    

    [window makeKeyAndVisible];
    
}

@end
