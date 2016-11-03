//
//  Component.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAObject.h"

@interface MIAComponent : MIAObject
@property (nonatomic,strong) NSDictionary *definition;

- (instancetype)initWithName:(NSString *)name uid:(NSString *)uid;
- (void)updateArgs:(NSDictionary *)args;
- (void)updateTargetUID:(NSString *)target_uid;

@end
