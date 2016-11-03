//
//  StackView.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MIAUIObject.h"
#import "MIAObject.h"
@class StackView;

@protocol StackViewProtocol <NSObject>

-(void)stackView:(StackView *)stackView wantsToUp:(BOOL)up object:(MIAUIObject *)uiobject completion:(void (^)(NSArray <MIAObject *> *objects))compBlock;

@end
@interface StackView : NSScrollView <MIAUIObjectProtocol>

-(void)addView:(MIAUIObject *)view;
-(void)removeView:(MIAUIObject *)view;
-(void)removeAll;
-(void)cycleObjects:(void(^)(MIAUIObject *object))cycle;
-(void)updateObjectWithId:(NSString *)uid withData:(NSDictionary *)data;
-(void)reorder:(NSArray <MIAObject *> *)objects;

@end
