//
//  StyleElementsTableSource.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StyleElementsTableSource.h"

@interface StyleElementItem : NSObject
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *type;

@end
@implementation StyleElementItem



@end

@interface StyleElementsTableSource(){
    NSArray *_datasource;
}

@end
@implementation StyleElementsTableSource
-(void)updateDataSource:(NSArray *)datasource{
    self->_datasource = datasource;
}
- (NSInteger)numberOfRowsInTableView:(NSTableView*)tableView {
    return self->_datasource.count;
}
- (id)tableView:(NSTableView*)tableView
objectValueForTableColumn:(NSTableColumn*)tableColumn
            row:(NSInteger)row {
    NSDictionary *item = [self->_datasource objectAtIndex:row];
    return [item objectForKey:@"key"];
}
- (void)tableViewSelectionDidChange:(NSNotification*)notification {
    if (notification == nil) {
        return;
    }
    NSTableView* tableView = notification.object;
    if ((long)tableView.selectedRow >= 0) {
        NSDictionary *item = [self->_datasource objectAtIndex:(long)tableView.selectedRow];
        
        if ([self.sourceDelegate respondsToSelector:@selector(tableDataSource:didSelectItem:)]) {
            if ((long)tableView.selectedRow >= 0) {
                [self.sourceDelegate tableDataSource:self didSelectItem:item];
            }
        }
    }
    
}
@end
