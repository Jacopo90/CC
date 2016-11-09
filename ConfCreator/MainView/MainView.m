//
//  MainView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 09/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MainView.h"
#import "Utils.h"

@implementation MainView

- (void)drawRect:(NSRect)dirtyRect {
    [[Utils colorWithHexColorString:@"2c7593" alpha:1] set];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
@end
