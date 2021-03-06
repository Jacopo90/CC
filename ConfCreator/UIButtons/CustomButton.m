//
//  CustomButton.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "CustomButton.h"
#import "Utils.h"

@interface CustomButton()
@property (nonatomic,weak) NSTextField *text;
@end
@implementation CustomButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self layerInit];
    }
    return self;
}
- (void)layerInit {
    CALayer* lay = [CALayer layer];
    
    lay.cornerRadius = self.bounds.size.height/2;
    lay.borderColor = [[Utils colorWithHexColorString:@"ffffff" alpha:0.1] CGColor];
    lay.borderWidth = 3;
    self.layer = lay;
    [self setWantsLayer:YES];
    
    NSTextField * text= [[NSTextField alloc] init];
    [self addSubview:text];
    text.editable = NO;
    text.backgroundColor = [NSColor clearColor];
    text.textColor = [NSColor whiteColor];
    text.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:19];
    [text setAcceptsTouchEvents:NO];
    text.alignment = NSTextAlignmentCenter;
    text.drawsBackground = NO;
    text.bezeled = NO;
    [text setSelectable:NO];
    [text setUserActivity:nil];
    [text setWantsRestingTouches:YES];
    text.stringValue = self.title;
    self.text = text;
    CGFloat stringHeight = self.attributedStringValue.size.height;

    text.frame = NSMakeRect(0, self.frame.size.height/2 - stringHeight+2, self.frame.size.width, self.frame.size.height);
}
-(void)changeMainColor:(NSColor *)color{ // to do : change name!!!s
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    self.layer.borderColor = [color CGColor];
}
-(void)changeTextColor:(NSColor *)color{
    self.text.textColor = color;
}
-(void)changeFont:(NSFont *)font{
    self.text.font = font;
}
-(void)changeText:(NSString *)text{
    self.text.stringValue = text;
}
-(void)changeOffsetY:(CGFloat)offsetY{
    self.text.frame = CGRectMake(self.text.frame.origin.x, self.text.frame.origin.y+offsetY, self.text.frame.size.width, self.text.frame.size.height);
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
