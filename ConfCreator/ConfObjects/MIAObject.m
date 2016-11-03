//
//  MIAObject.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAObject.h"
@interface MIAObject(){

}
@end

@implementation MIAObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uuid = [[NSUUID UUID] UUIDString];

    }
    return self;
}
- (NSDictionary *)dataDict{return nil;}
- (void)update:(NSDictionary *)newJson completion:(void (^)(NSDictionary *))compBlock{}

@end
