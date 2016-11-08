//
//  MIAObjectsDecoder.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAComponent.h"
#import "MIAJunction.h"
#import "MIAStyle.h"

@interface MIAObjectsDecoder : NSObject
+(NSArray <MIAComponent *>*)componentsFromJson:(NSDictionary *)jsonDict;
+(NSArray <MIAJunction *>*)junctionsFromJson:(NSDictionary *)jsonDict withComponents:(NSArray<MIAComponent *>*)components;
+(NSArray <MIAStyle *> *)stylesFromJson:(NSDictionary *)jsonDict withComponents:(NSArray <MIAComponent *> *)components;

@end
