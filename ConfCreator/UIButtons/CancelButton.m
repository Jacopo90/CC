//
//  CancelButton.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "CancelButton.h"
#import "Utils.h"

@interface CancelButton()
@property (nonatomic,weak) NSTextField *text;

@end
@implementation CancelButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
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
    
    lay.cornerRadius = self.bounds.size.width/2;
    lay.backgroundColor = [[Utils colorWithHexColorString:@"ffffff" alpha:0] CGColor];

    self.layer = lay;
    [self setWantsLayer:YES];
    
    NSTextField * text= [[NSTextField alloc] init];
    [self addSubview:text];
    text.editable = NO;
    text.backgroundColor = [NSColor clearColor];
    text.textColor = [Utils colorWithHexColorString:@"eda031" alpha:1];
    text.font = [NSFont fontWithName:@"FontAwesome" size:14];
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
    self.text.stringValue = @"\uf00d";
    text.frame = NSMakeRect(0, self.frame.size.height/2 - stringHeight+2, self.frame.size.width, self.frame.size.height);
}
@end
