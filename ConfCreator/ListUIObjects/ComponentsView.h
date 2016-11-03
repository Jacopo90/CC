//
//  ConfigurationView.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAUIComponent.h"
#import "StackView.h"
#import "MIAComponent.h"
@class ComponentsView;

@protocol ComponentsViewProtocol <StackViewProtocol>

-(void)componentsView:(ComponentsView *)view wantsRemoveComponentWithId:(NSString *)uuid completion:(void (^)(void))compBlock;
-(void)componentsView:(ComponentsView *)view tappedComponentWithId:(NSString *)uuid;

@end

@interface ComponentsView : StackView
@property(nonatomic,weak) id <ComponentsViewProtocol> delegate;
-(void)addComponent:(MIAComponent *)component;

@end
