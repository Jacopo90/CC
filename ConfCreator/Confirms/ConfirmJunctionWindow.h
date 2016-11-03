//
//  ConfirmJunctionWindow.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MIAJunction.h"

@class ConfirmJunctionWindow;

@protocol JunctionWindowProtocol <NSObject>
-(void)confirmJunctionWindow:(ConfirmJunctionWindow *)window didConfirmJunction:(MIAJunction *)junction;

@end
@interface ConfirmJunctionWindow : NSWindowController
-(instancetype)initWithWindowNibName:(NSString *)windowNibName components:(NSArray <MIAComponent *> *)components;

@property (nonatomic,weak) id <JunctionWindowProtocol> delegate;

@end
