//
//  JunctionsLinker.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 05/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAJunction.h"
#import <Cocoa/Cocoa.h>

@interface JunctionsChain:NSObject
-(NSColor *)chainColor;
-(void)cycleList:(void(^)(MIAJunction *junction))cyler;

@end

@class JunctionsLinker;
@protocol JunctionsLinkerProtocol<NSObject>
-(NSArray <MIAJunction *> *)junctionsLinker:(JunctionsLinker *)linker askJunctions:(BOOL)ask;
@end
@interface JunctionsLinker : NSObject
-(instancetype)initWithDelegate:(id)delegate;
-(void)buildChains;
-(NSMutableArray <JunctionsChain *> *)chains;
-(void)addJunction:(MIAJunction *)junction;


@end
