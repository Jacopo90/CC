//
//  MIAConfiguration.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAComponent.h"
#import "MIAJunction.h"
#import "MIAStyle.h"


@interface MIAConfiguration : NSObject

- (BOOL)addComponent:(MIAComponent *)component;
- (BOOL)addJunction:(MIAJunction *)junction;
- (BOOL)addStyle:(MIAStyle *)style;

- (BOOL)removeFromID:(NSString *)uid;
- (BOOL)removeComponent:(MIAComponent *)component;
- (BOOL)removeJunction:(MIAJunction *)junction;
- (BOOL)removeStyle:(MIAStyle *)style;
- (void)removeAll:(void(^)(BOOL success))completion;

- (BOOL)isEmpty;

- (id)objectFromID:(NSString *)uid;
- (NSArray <MIAComponent *> *)components;
- (NSArray <MIAJunction *> *)junctions;
- (NSArray <MIAStyle *> *)styles;

- (void)cycleObjects:(void(^)(MIAObject *object))cycle;

- (BOOL)moveObject:(MIAObject *)object up:(BOOL)up;


@end
