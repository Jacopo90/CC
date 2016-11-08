//
//  StylerView.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StackView.h"
#import "MIAStyle.h"
#import "MIAUIStyle.h"
@class StylerView;

@protocol StylerViewProtocol <StackViewProtocol>

-(void)stylerView:(StylerView *)view wantsRemoveStyleWithId:(NSString *)uuid completion:(void (^)(void))compBlock;
-(void)stylerView:(StylerView *)view tappedStyleWithId:(NSString *)uuid;

@end

@interface StylerView : StackView
@property(nonatomic,weak) id <StylerViewProtocol> delegate;

-(void)addStyle:(MIAStyle *)style;
-(void)forceRemoveStyleWithId:(NSString *)styleUID;

@end
