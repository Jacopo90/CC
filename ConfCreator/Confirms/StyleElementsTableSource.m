//
//  StyleElementsTableSource.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StyleElementsTableSource.h"
@interface StyleElementItem : NSObject{
    NSString *_key;
    NSString *_type;

}
@property (nonatomic,strong) id value; // this is the all dictionary
@end

@implementation StyleElementItem
- (instancetype)initWithKey:(NSString *)key type:(NSString *)type
{
    self = [super init];
    if (self) {
        self->_key = key;
        self->_type = type;
    }
    return self;
}
-(NSString *)key{
    return self->_key;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"key : %@ - type : %@ - value : %@",self->_key,self->_type,self.value];
}
-(NSDictionary *)definition{
    return @{@"key":self->_key,
             @"type":self->_type};
}
@end

@interface StyleElementsTableSource(){
    NSMutableArray *_datasource;
}

@end
@implementation StyleElementsTableSource
- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_datasource = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)addItemWithKey:(NSString *)key type:(NSString *)type{
    
    for (StyleElementItem *eItem in self->_datasource) {
        [[eItem key] isEqualToString:key];
        break;
        return;
    }
    
    StyleElementItem *item = [[StyleElementItem alloc]initWithKey:key type:type];
    [self->_datasource addObject:item];
}
-(void)clean{
    [self->_datasource removeAllObjects];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView*)tableView {
    return self->_datasource.count;
}

- (id)tableView:(NSTableView*)tableView
objectValueForTableColumn:(NSTableColumn*)tableColumn
            row:(NSInteger)row {
    StyleElementItem *item = [self->_datasource objectAtIndex:row];
    return item.key;
}
- (void)tableViewSelectionDidChange:(NSNotification*)notification {
    if (notification == nil) {
        return;
    }
    
    NSTableView* tableView = notification.object;
    if ((long)tableView.selectedRow >= 0) {
        StyleElementItem *item = [self->_datasource objectAtIndex:(long)tableView.selectedRow];
        
        if ([self.sourceDelegate respondsToSelector:@selector(tableDataSource:didSelectItem:)]) {
            if ((long)tableView.selectedRow >= 0) {
                [self.sourceDelegate tableDataSource:self didSelectItem:[item definition]];
            }
        }
    }
}
-(void)changeValue:(id)value forItemWithKey:(NSString *)key{
    for (StyleElementItem *item in self->_datasource) {
        if ([item.key isEqualToString:key]) {
            item.value = value;
            break;
        }
    }
}
-(NSArray *)datasource{
    
    NSMutableArray *uiValues = [[NSMutableArray alloc]init];
    for (StyleElementItem *item in self->_datasource) {
        NSMutableDictionary *uielem = [[NSMutableDictionary alloc]init];
        [uielem setObject:item.key forKey:@"key"];
        if (item.value) {
            [uielem setObject:item.value forKey:@"value"]; // this is the all dictionary
        }
        [uiValues addObject:uielem];
    }
    return uiValues;
}

@end
