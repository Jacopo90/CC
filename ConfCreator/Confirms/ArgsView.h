//
//  ArgsView.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 09/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ArgsView;
@protocol ArgsViewProtocol <NSObject>
- (void)argsView:(ArgsView *)argsview validDictionary:(NSDictionary *)dictionary;
- (void)argsView:(ArgsView *)argsview errorDictionary:(NSError *)error;

@end

@interface ArgsView : NSTextView
@property (nonatomic,weak) id <ArgsViewProtocol> argsViewdelegate;
@property (nonatomic,strong) NSString *argsViewIdentifier;

-(NSDictionary *)dictionary;
-(void)addParameters:(NSArray *)inputParameters;
-(void)cleanView;
-(NSDictionary *)validate;

@end
