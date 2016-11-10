//
//  CustomView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 09/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "CustomView.h"
#import <XUIKit/XUIKit.h>

@interface CustomView(){
    NSColor *_bgColor;
}
@end

@implementation CustomView
-(BOOL)wantsDefaultClipping{
    
    return NO;
}
-(void)setBgColor:(NSColor *)color{
    self->_bgColor = color;
    [self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)dirtyRect {
    [self->_bgColor set];
    NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:XUIRectCornerTopLeft|XUIRectCornerBottomLeft cornerRadii:CGSizeMake(6, 6)];
//    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:10 yRadius:10];
    [path addClip];
    NSRectFill(dirtyRect);

    [super drawRect:dirtyRect];

    // Drawing code here.
}

@end
