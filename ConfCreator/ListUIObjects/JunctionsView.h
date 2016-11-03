//
//  JunctionsView.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StackView.h"
#import "MIAJunction.h"
@class JunctionsView;

@protocol JunctionsViewProtocol <StackViewProtocol>

-(void)junctionsView:(JunctionsView *)view wantsRemoveJunctionWithId:(NSString *)uuid completion:(void (^)(void))compBlock;
-(void)junctionsView:(JunctionsView *)view tappedJunctionWithId:(NSString *)uuid;

@end

@interface JunctionsView : StackView
@property(nonatomic,weak) id <JunctionsViewProtocol> delegate;
-(void)forceRemoveJunctionWithId:(NSString *)junctionID;
-(void)addJunction:(MIAJunction *)uijunction;

@end
