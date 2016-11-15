//
//  MIAStyle.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAStyle.h"
#import "StyleDefinitions.h"

@interface MIAStyleUIElement: NSObject{
    StyleUIDefinition *_definition;
}
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSMutableDictionary *properties;

@end
@implementation MIAStyleUIElement
- (instancetype)initWithKey:(NSString *)key values:(NSDictionary *)value
{
    self = [super init];
    if (self) {
        self.key = key;
        self.properties = [[NSMutableDictionary alloc]init];
        if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in value) {
                [self setProperty:[value objectForKey:key] forKey:key];
            }
            
        }
        
        
    }
    return self;
}
-(void)setProperty:(id)propertyValue forKey:(NSString *)key{
    [self.properties setObject:propertyValue forKey:key];
}
-(NSDictionary *)emptyProperties{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc]init];
    for (NSString *key in self->_definition) {
        [properties setObject:@"" forKey:key]; // here you can choose to add a default value
    }
    return properties;
}
@end



@interface MIAStyle(){
    MIAComponent *_privateComponent;
    NSMutableArray <MIAStyleUIElement *> *styleElements;
}
@end
@implementation MIAStyle
- (instancetype)initWithComponent:(MIAComponent *)component uiElements:(NSArray *)elements{
    self = [super init];
    if (self) {
        self->_privateComponent = component;
        self->styleElements = [[NSMutableArray alloc]init];
        for (NSDictionary *element in elements) {
            NSString *key = [element objectForKey:@"key"];
            NSDictionary *value = [element objectForKey:@"value"]; // this is the all dictionary
            if (![value isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            if (key == nil || value == nil || value.count == 0) {
                continue;
            }
            MIAStyleUIElement *styleElement = [[MIAStyleUIElement alloc]initWithKey:key values:value];
            [self->styleElements addObject:styleElement];
        }
    }
    return self;
}
-(NSString *)componentUID{
    return [self->_privateComponent uuid];
}
-(NSDictionary *)dataDict{
    NSMutableDictionary *rules = [[NSMutableDictionary alloc]init];
    for (MIAStyleUIElement *styleElement in self->styleElements) {
        [rules setObject:styleElement.properties forKey:styleElement.key];
    }
    NSMutableDictionary *mainDict = [[NSMutableDictionary alloc]init];
    [mainDict setObject:[[self->_privateComponent dataDict] objectForKey:@"uid"] forKey:@"id"];
        [mainDict setObject:rules forKey:@"rules"];
    
    return mainDict;
}
-(void)update:(NSDictionary *)newJson completion:(void (^)(NSDictionary *))compBlock{
   
    [self->styleElements removeAllObjects];
    NSDictionary *rules = [newJson objectForKey:@"rules"];
    for (NSString *key in rules) {
        MIAStyleUIElement *styleElement = [[MIAStyleUIElement alloc]initWithKey:key values:[rules objectForKey:key]];
        [self->styleElements addObject:styleElement];
    }
    compBlock([self dataDict]);
}
@end
