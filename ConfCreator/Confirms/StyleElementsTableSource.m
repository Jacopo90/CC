//
//  StyleElementsTableSource.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StyleElementsTableSource.h"

@implementation StyleElementItem

-(NSString *)description{
    return [NSString stringWithFormat:@"key : %@ - type : %@ - value : %@",self.key,self.type,self.value];
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
-(void)updateDataSource:(NSArray <StyleElementItem *> *)datasource{
    [self->_datasource setArray:datasource];
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
                [self.sourceDelegate tableDataSource:self didSelectItem:item];
            }
        }
    }
}
-(NSArray <StyleElementItem *> *)datasource{
    return self->_datasource;
}
-(void)changeValue:(id)value forItemWithKey:(NSString *)key{
    for (StyleElementItem *item in self->_datasource) {
        if ([item.key isEqualToString:key]) {
            item.value = value;
            break;
        }
    }
}
@end
