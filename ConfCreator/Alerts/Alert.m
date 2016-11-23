//
//  Alert.m
//  Cappuccino
//
//  Created by Jacopo Pappalettera on 23/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "Alert.h"
@interface Alert()<NSAlertDelegate>

@end
@implementation Alert
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(void(^)(void))confirmBlock cancelBlock:(void(^)(void))cancelBlock inWindow:(NSWindow *)window style:(NSAlertStyle)style{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"ok"];
    [alert addButtonWithTitle:@"cancel"];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert setAlertStyle:style];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        switch (returnCode) {
            case NSModalResponseStop:{
                confirmBlock();
            }
                break;
            case NSModalResponseAbort:{
                cancelBlock();
            }
            case 1000:{
                confirmBlock();
            }
            case 1001:{
                cancelBlock();
            }
                break;
            default:
                break;
        }
    }];
}

@end
