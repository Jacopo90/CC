//
//  MIAUIObject.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAUIObject.h"
@interface MIAUIObject (){
    NSString *_uuid;
    BOOL _is_selected;
}

@end

@implementation MIAUIObject

-(void)mouseDown:(NSEvent *)theEvent{
    [self.window mouseDown:theEvent];
    [self.delegate uiObject:self tapped:YES];
}
- (IBAction)remove:(id)sender {
    [self.delegate uiObject:self remove:YES];
}
+(id)loadFromWithUUID:(NSString *)uuid type:(NSString *)type frame:(CGRect)frame{
    NSArray *views = nil;
    [[NSBundle mainBundle] loadNibNamed:type owner:self topLevelObjects:&views];
    MIAUIObject *customView = nil;
    for (id obj in views) {
        if ([obj isKindOfClass:[MIAUIObject class]]) {
            customView =  obj;
            break;
        }
    }
    customView->_uuid = uuid;
    customView.frame = frame;


    return customView;
}


-(void)select:(BOOL)select{
    self->_is_selected = select;
    [self setNeedsDisplay:YES];
}

-(NSString *)uuid{
    return self->_uuid;
}
-(void)bindData:(NSDictionary *)data{
    
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect rect = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:20 yRadius:20];
    [path addClip];    
 
    [self defaultStyle];
    [self customStyle];
    NSRectFill(dirtyRect);
    
    
    if (self->_is_selected) {
        [self selectStyle];
        NSRectFill(dirtyRect);
        return;
    }
}
- (IBAction)up:(id)sender {
    [self.delegate uiObject:self up:YES];
}
- (IBAction)down:(id)sender {
    [self.delegate uiObject:self up:NO];
}

-(void)selectStyle{}
-(void)defaultStyle{}
-(void)customStyle{}

@end
