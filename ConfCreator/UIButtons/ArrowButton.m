//
//  ArrowButton.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 01/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ArrowButton.h"
#import "Utils.h"

@interface ArrowButton()
@property (nonatomic,weak) NSTextField *text;

@end
@implementation ArrowButton

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
    text.textColor = [Utils colorWithHexColorString:@"ffffff" alpha:0.5];
    text.font = [NSFont fontWithName:@"FontAwesome" size:15];
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
-(void)upArrow:(BOOL)upArrow{
    if (upArrow) {
        self.text.stringValue = @"\uf062";
    }else{
        self.text.stringValue = @"\uf063";
    }
}
@end
