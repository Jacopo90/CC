//
//  Component.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAComponent.h"

@interface MIAComponent () {
    NSString *_name;
    NSString *_uid;
    NSDictionary *_args;
    NSString *_target_uid;

}
@end

@implementation MIAComponent
- (instancetype)initWithName:(NSString *)name uid:(NSString *)uid{
    self = [super init];
    if (self) {
        self->_name = name;
        self->_uid = uid;
    }
    return self;
}
-(void)updateArgs:(NSDictionary *)args{
    self->_args = args;
}
-(void)updateTargetUID:(NSString *)target_uid{
    self->_target_uid = target_uid;
}
-(NSDictionary *)dataDict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self->_name forKey:@"name"];
    [dict setObject:self->_uid forKey:@"uid"];
    if (self->_target_uid != nil) {
        [dict setObject:self->_target_uid forKey:@"target_uid"];
    }
    if (self->_args) {
        [dict setObject:self->_args forKey:@"args"];
    }
    return (NSDictionary *)dict;
    
}
-(void)update:(NSDictionary *)newJson completion:(void (^)(NSDictionary *))compBlock
{
    if ([newJson objectForKey:@"name"]) {
        self->_name = [newJson objectForKey:@"name"];
    }
    if ([newJson objectForKey:@"uid"]) {
        self->_uid = [newJson objectForKey:@"uid"];
    }
    if ([newJson objectForKey:@"args"]) {
        [self updateArgs:[newJson objectForKey:@"args"]];
    }
    if ([newJson objectForKey:@"target_uid"]) {
        [self updateTargetUID:[newJson objectForKey:@"target_uid"]];
    }
    
    compBlock([self dataDict]);
}
@end
