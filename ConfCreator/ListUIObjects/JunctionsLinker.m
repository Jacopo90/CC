//
//  JunctionsLinker.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 05/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "JunctionsLinker.h"
#import "Utils.h"

@interface JunctionsChain()
{
    NSMutableArray<MIAJunction*> *_list;
    NSColor *_color;
}

@end
@implementation JunctionsChain
- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_color = [Utils randomColor];
        self->_list = [[NSMutableArray alloc]init];
    }
    return self;
}
-(NSColor *)chainColor{
    return self->_color;
}
-(void)addJunction:(MIAJunction *)junction{
    [self->_list addObject:junction];
}
-(MIAJunction *)lastJunction{
    return [self->_list lastObject];
}
-(void)cycleList:(void(^)(MIAJunction *junction))cyler{
    for (MIAJunction *junction in self->_list) {
        cyler(junction);
    }
}
@end


@interface JunctionsLinker(){
    NSMutableArray <JunctionsChain *> *_chains;
}
@property (nonatomic,weak) id<JunctionsLinkerProtocol> delegate;

@end
@implementation JunctionsLinker
- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self->_chains = [[NSMutableArray alloc]init];
        self.delegate = delegate;
    }
    return self;
}
-(NSArray *)junctionsInChains{
    NSMutableArray *main = [[NSMutableArray alloc]init];
    for (JunctionsChain *chain in self->_chains) {
        [chain cycleList:^(MIAJunction *junction) {
            [main addObject:junction];
        }];
    }
    return main;
}

-(void)buildChains{
    [self.chains removeAllObjects];
    
    NSArray *junctions = [self.delegate junctionsLinker:self askJunctions:YES];
    for (MIAJunction *j in junctions) {
        if (![[self junctionsInChains] containsObject:j]) {
            BOOL added = NO;
            for (JunctionsChain *chain in self->_chains) {
                MIAJunction *lastJunctionInChain = [chain lastJunction];
                if ([[lastJunctionInChain receiverUUID] isEqualToString:j.senderUUID]) {
                    [chain addJunction:j];
                    added = YES;
                    break;
                }
            }
            if (!added) {
                JunctionsChain *chain = [[JunctionsChain alloc]init];
                [chain addJunction:j];
                [self->_chains addObject:chain];
                
            }
        }
    }
}

-(void)addJunction:(MIAJunction *)junction{
  
}
-(NSMutableArray <JunctionsChain *> *)chains{
    return self->_chains;
}

@end
