//
//  StylerView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StylerView.h"
#import "Utils.h"

@implementation StylerView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[Utils colorWithHexColorString:@"ffffff" alpha:1] set];
    NSRectFill(dirtyRect);
    // Drawing code here.
}
-(void)addStyle:(MIAStyle *)style{
    CGRect frame = CGRectMake(10, 0, self.bounds.size.width-20, 80);
    MIAUIStyle *uiview = [MIAUIStyle loadFromWithUUID:style.uuid type:@"MIAUIStyle" frame:frame];
    uiview.delegate = self;
    [self addView:uiview];
    
    [uiview bindData:[style dataDict]];
}

-(void)forceRemoveStyleWithId:(NSString *)styleUID{
    
    __block MIAUIObject *tmpObject = nil;
    [self cycleObjects:^(MIAUIObject *object) {
        if ([[object uuid] isEqualToString:styleUID]) {
            tmpObject = object;
        }
    }];
    if (!tmpObject) {
        return;
    }
    [self removeView:tmpObject];
}
#pragma mark - uiobject delegate -
-(void)uiObject:(MIAUIObject *)uiobject remove:(BOOL)remove{
    if (!remove) {
        return;
    }
    [self.delegate stylerView:self wantsRemoveStyleWithId:uiobject.uuid completion:^{
        [self removeView:uiobject];
    }];
   
}
-(void)uiObject:(MIAUIObject *)uiobject tapped:(BOOL)tapped{
    [self.delegate stylerView:self tappedStyleWithId:uiobject.uuid];
    
}
-(void)uiObject:(MIAUIObject *)uiobject up:(BOOL)up{
 // to do : implement if necessary..
}

#pragma mark - styles -


@end
