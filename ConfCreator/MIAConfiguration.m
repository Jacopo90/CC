//
//  MIAConfiguration.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAConfiguration.h"

@interface MIAConfiguration(){
    NSMutableArray <MIAComponent *> *components;
    NSMutableArray <MIAJunction *> *junctions;
    NSMutableArray <MIAStyle *> *styles;
}
@end

@implementation MIAConfiguration

- (instancetype)init{
    self = [super init];
    if (self) {
        self->components = [[NSMutableArray alloc]init];
        self->junctions = [[NSMutableArray alloc]init];
        self->styles = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - adding -
- (BOOL)addComponent:(MIAComponent *)component{
    [self->components addObject:component];
    NSLog(@"sono deborah : lumaca");
    return [self->components containsObject:component];
    
}
- (BOOL)addJunction:(MIAJunction *)junction{
    [self->junctions addObject:junction];
    return [self->junctions containsObject:junction];
}
- (BOOL)addStyle:(MIAStyle *)style{
    [self->styles addObject:style];

    return [self->styles containsObject:style];
}

#pragma mark - removing -
- (BOOL)removeFromID:(NSString *)uid{
    
    for (MIAComponent *component in self->components) {
        if ([component.uuid isEqualToString:uid]) {
            [self removeComponent:component];
            return YES;
            break;
        }
    }
    
    for (MIAJunction *junction in self->junctions) {
        if ([junction.uuid isEqualToString:uid]) {
            [self removeJunction:junction];
            return YES;
            break;
        }
    }
    for (MIAStyle *style in self->styles) {
        if ([style.uuid isEqualToString:uid]) {
            [self removeStyle:style];
            return YES;
            break;
        }
    }

    return NO;
}
- (BOOL)removeComponent:(MIAComponent *)component{
    [self->components removeObject:component];
    return  ![self->components containsObject:component];
}
- (BOOL)removeJunction:(MIAJunction *)junction{
    [self->junctions removeObject:junction];
    return ![self->junctions containsObject:junction];
}
- (BOOL)removeStyle:(MIAStyle *)style{
    [self->styles removeObject:style];
    return ![self->styles containsObject:style];
}
-(void)removeAll:(void(^)(BOOL success))completion{

    [self->components removeAllObjects];
    [self->junctions removeAllObjects];
    [self->styles removeAllObjects];
    
    if (self->components.count == 0 && self->junctions.count == 0 && self->styles.count == 0) {
        completion(YES);
    }
}
#pragma mark - getting -
-(id)objectFromID:(NSString *)uid{
    
    for (MIAComponent *component in self->components) {
        if ([component.uuid isEqualToString:uid]) {
            return component;
            break;
        }
    }
    for (MIAJunction *junction in self->junctions) {
        if ([junction.uuid isEqualToString:uid]) {
            return junction;
            break;
        }
    }
    for (MIAStyle *style in self->styles) {
        if ([style.uuid isEqualToString:uid]) {
            return style;
            break;
        }
    }
    return nil;
}
-(NSArray <MIAComponent *> *)components{
    return self->components;
}
-(NSArray <MIAJunction *> *)junctions{
    return self->junctions;
}
-(NSArray <MIAStyle *> *)styles{
    return self->styles;
}

-(void)cycleObjects:(void(^)(MIAObject *object))cycle{
    
    NSMutableArray *all = [[NSMutableArray alloc]init];
    [all addObjectsFromArray:self->components];
    [all addObjectsFromArray:self->junctions];
    [all addObjectsFromArray:self->styles];

    for (MIAObject *obj in all) {
        cycle(obj);
    }
}
#pragma mark - updating -

#pragma mark - reordering -
-(BOOL)moveObject:(MIAObject *)object up:(BOOL)up{
    NSInteger move = up?-1:+1;
    
    if([object isKindOfClass:[MIAComponent class]]){
        NSInteger index = [self->components indexOfObject:(MIAComponent *)object];
        if (index+move > self.components.count-1 || index+move < 0) {
            return NO;
        }

        MIAComponent *prevObject = [self.components objectAtIndex:index+move];
        [self->components replaceObjectAtIndex:index+move withObject:(MIAComponent *)object];
        [self->components replaceObjectAtIndex:index withObject:(MIAComponent *)prevObject];
        return YES;
    }
    if ([object isKindOfClass:[MIAJunction class]]) {
        NSInteger index = [self->junctions indexOfObject:(MIAJunction *)object];
        if (index+move > self.junctions.count-1 || index+move < 0) {
            return NO;
        }
        MIAJunction *prevObject = [self.junctions objectAtIndex:index+move];
        [self->junctions replaceObjectAtIndex:index+move withObject:(MIAJunction *)object];
        [self->junctions replaceObjectAtIndex:index withObject:(MIAJunction *)prevObject];
        return YES;
    }
    return NO;
}


@end
