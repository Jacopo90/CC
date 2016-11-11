//
//  AppDelegate.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 27/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <UIKit/UIKitView.h>

@class ChameleonAppDelegate;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    ChameleonAppDelegate *chameleonApp;
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet UIKitView *chameleonNSView;
@end

