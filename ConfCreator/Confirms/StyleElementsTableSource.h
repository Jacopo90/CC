//
//  StyleElementsTableSource.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Cocoa/Cocoa.h>
@class StyleElementsTableSource;
@protocol StyleElementTableDataSourceProtocol<NSObject>
-(void)tableDataSource:(StyleElementsTableSource *)tableDataSource didSelectItem:(id)item;

@end
@interface StyleElementsTableSource : NSObject  <NSTableViewDelegate,NSTableViewDataSource>
@property (nonatomic,weak) id <StyleElementTableDataSourceProtocol> sourceDelegate;
-(void)updateDataSource:(NSArray *)datasource;

@end
