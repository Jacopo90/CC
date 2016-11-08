//
//  ConfirmComponentWindow.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MIAComponent.h"
#import "MIAStyle.h"

@class ConfirmComponentWindow;

@protocol ComponentWindowProtocol <NSObject>
-(void)confirmComponentWindow:(ConfirmComponentWindow *)window didConfirmComponent:(MIAComponent *)component withAssociatedStyle:(MIAStyle *)style;

@end
@interface ConfirmComponentWindow : NSWindowController
@property (nonatomic,weak) id <ComponentWindowProtocol> delegate;
@end
