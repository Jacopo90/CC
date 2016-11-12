//
//  ArgsDataSource.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 12/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ArgsDataSource.h"
@interface Argoument: NSObject{
    NSString *_name;
    NSString *_type;
    id _defaultValue;
    NSArray *_values;
}
@property (nonatomic,strong) id value;
@end
@implementation Argoument
- (instancetype)initWithName:(NSString *)name type:(NSString *)type defaultValue:(id)defaultValue values:(NSArray *)values
{
    self = [super init];
    if (self) {
        self->_name = name;
        self->_type = type;
        self->_defaultValue = defaultValue;
        self->_values = values;
    }
    return self;
}
-(NSString *)name{
    return self->_name;
}
@end
@interface ArgsDataSource(){
    NSMutableArray <Argoument *> *_datasource;
}
@end

@implementation ArgsDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_datasource = [[NSMutableArray alloc]init];
    }
    return self;
}
-(NSArray *)keys{
    NSMutableArray *arrayKeys = [[NSMutableArray alloc]init];
    for (Argoument *arg in self->_datasource) {
        [arrayKeys addObject:[arg name]];
    }
    return arrayKeys;
}
-(NSDictionary *)datasource{
    NSMutableDictionary *dictDataSource = [[NSMutableDictionary alloc]init];
    for (Argoument *arg in self->_datasource) {
        if (arg.value != nil) {
            [dictDataSource setObject:arg.value forKey:[arg name]];
        }
    }
    return dictDataSource;
}
-(void)addItemWithName:(NSString *)name type:(NSString *)type defaultValue:(id)defaultValue values:(NSArray *)values{
    Argoument *arg = [[Argoument alloc]initWithName:name type:type defaultValue:defaultValue values:values];
    [self->_datasource addObject:arg];
}
-(void)clean{
    [self->_datasource removeAllObjects];
}
-(void)updateArgs:(NSMutableArray <Argoument *>*)args{
    [self->_datasource setArray:args];
}

-(void)changeValue:(id)value forItemWithKey:(NSString *)key{
    for (Argoument *argoument in self->_datasource) {
        if ([argoument.name isEqualToString:key]) {
            argoument.value = value;
            break;
        }
    }
}
@end
