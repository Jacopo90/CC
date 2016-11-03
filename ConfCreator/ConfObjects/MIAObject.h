//
//  MIAObject.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIAObject : NSObject
@property (nonatomic,strong) NSString *uuid;
- (NSDictionary *)dataDict;
- (void)update:(NSDictionary *)newJson completion:(void (^)(NSDictionary *dict))compBlock;
@end
