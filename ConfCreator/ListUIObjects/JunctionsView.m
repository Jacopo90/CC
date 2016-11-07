//
//  JunctionsView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "JunctionsView.h"
#import "MIAUIJunction.h"
#import "Utils.h"
@interface JunctionsView (){
    
    
}

@end

@implementation JunctionsView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[Utils colorWithHexColorString:@"ffffff" alpha:1] set];
    NSRectFill(dirtyRect);
    // Drawing code here.
}
-(void)addJunction:(MIAJunction *)uijunction{
    CGRect frame = CGRectMake(10, 0, self.bounds.size.width-20, 120);
    MIAUIJunction *uiview = [MIAUIJunction loadFromWithUUID:uijunction.uuid type:@"MIAUIJunction" frame:frame];
    uiview.delegate = self;
    [self addView:uiview];
    
    [uiview bindData:[uijunction dataDict]];
}

-(void)forceRemoveJunctionWithId:(NSString *)junctionID{
    
    __block MIAUIObject *tmpObject = nil;
    [self cycleObjects:^(MIAUIObject *object) {
        if ([[object uuid] isEqualToString:junctionID]) {
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
    [self.delegate junctionsView:self wantsRemoveJunctionWithId:uiobject.uuid completion:^{
        [self removeView:uiobject];
    }];
}
-(void)uiObject:(MIAUIObject *)uiobject tapped:(BOOL)tapped{
    [self.delegate junctionsView:self tappedJunctionWithId:uiobject.uuid];
}
-(void)uiObject:(MIAUIObject *)uiobject up:(BOOL)up{
    [self.delegate stackView:self wantsToUp:up object:uiobject completion:^(NSArray<MIAObject *> *objects) {
        [self reorder:objects];
    }];
}

#pragma mark - styles -
-(void)applyStyleToJunctionChains:(NSArray <JunctionsChain *>*)chains{
    for (JunctionsChain *chain in chains) {
        [chain cycleList:^(MIAJunction *junction) {
            [self cycleObjects:^(MIAUIObject *object) {
                MIAUIJunction *uijunction = (MIAUIJunction *)object;
                if ([uijunction.uuid isEqualToString:junction.uuid]) {
                    [uijunction setBgColorForLinkedJunctionStyle:[chain chainColor]];
                    [uijunction setNeedsDisplay:YES];
                }
            }];
        }];
    }
}

-(void)applySelectStyle:(MIAUIObject *)uiobject{
    [self cycleObjects:^(MIAUIObject *object) {
        [object select:[object isEqual:uiobject]];
    }];
}
@end
