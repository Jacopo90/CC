//
//  MIAStyle.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAStyle.h"
@interface MIAStyle(){
    NSString *_uid;
}
@end
@implementation MIAStyle
- (instancetype)initWithUid:(NSString *)uid{
    self = [super init];
    if (self) {
        self->_uid = uid;
    }
    return self;
}
-(NSDictionary *)dataDict{
    return @{@"data_dict_styler":@"cazzo"};
}
-(void)update:(NSDictionary *)newJson completion:(void (^)(NSDictionary *))compBlock{
    // to do : to do 
    compBlock([self dataDict]);
}
@end
