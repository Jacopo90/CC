//
//  Alert.h
//  Cappuccino
//
//  Created by Jacopo Pappalettera on 23/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Alert : NSObject
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(void(^)(void))confirmBlock cancelBlock:(void(^)(void))cancelBlock inWindow:(NSWindow *)window style:(NSAlertStyle)style;

@end
