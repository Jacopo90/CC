//
//  ConfigurationView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ComponentsView.h"
#import "Utils.h"
@interface ComponentsView(){
    
}

@end
@implementation ComponentsView
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
-(void)addComponent:(MIAComponent *)component{
    CGRect frame = CGRectMake(10, 0, self.bounds.size.width-20, 80);
    MIAUIComponent *uiview = [MIAUIComponent loadFromWithUUID:component.uuid type:@"MIAUIComponent" frame:frame];
    uiview.delegate = self;
    [self addView:uiview];
    
    [uiview bindData:[component dataDict]];
    [uiview hideDefinition:[component definition] == nil];
}


#pragma mark - uiobject delegate -
-(void)uiObject:(MIAUIObject *)uiobject remove:(BOOL)remove{
    if (!remove) {
        return;
    }
    [self.delegate componentsView:self wantsRemoveComponentWithId:uiobject.uuid completion:^{
        [self removeView:uiobject];
    }];
}
-(void)uiObject:(MIAUIObject *)uiobject tapped:(BOOL)tapped{
    [self.delegate componentsView:self tappedComponentWithId:uiobject.uuid];
    [self applySelectStyle:uiobject];

}
-(void)uiObject:(MIAUIObject *)uiobject up:(BOOL)up{
    [self.delegate stackView:self wantsToUp:up object:uiobject completion:^(NSArray<MIAObject *> *objects) {
        [self reorder:objects];
    }];
}

#pragma mark - styles -
-(void)applySelectStyle:(MIAUIObject *)uiobject{
    [self cycleObjects:^(MIAUIObject *object) {
        [object select:[object isEqual:uiobject]];
    }];
}
@end
