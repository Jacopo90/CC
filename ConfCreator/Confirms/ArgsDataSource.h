//
//  ArgsDataSource.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 12/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArgsDataSource : NSObject
-(NSDictionary *)datasource;
-(NSArray *)keys;

-(void)updateArgs:(NSDictionary *)args;
-(void)changeValue:(id)value forItemWithKey:(NSString *)key;
-(void)addItemWithName:(NSString *)name type:(NSString *)type defaultValue:(id)defaultValue values:(NSArray *)values;
-(void)clean;
@end
