//
//  MenuView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MenuView.h"
#import "Utils.h"

@implementation MenuView
-(BOOL)mouseDownCanMoveWindow{
    return YES;
}
- (void)drawRect:(NSRect)dirtyRect {
//    [[Utils colorWithHexColorString:@"4C7768" alpha:1] set];
      [[Utils colorWithHexColorString:@"4C6073" alpha:1] set];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
    // Drawing code here.
  
}

@end
