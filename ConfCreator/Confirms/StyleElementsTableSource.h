//
//  StyleElementsTableSource.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Cocoa/Cocoa.h>

@interface StyleElementItem : NSObject
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) id value;
@end

@class StyleElementsTableSource;
@protocol StyleElementTableDataSourceProtocol<NSObject>
-(void)tableDataSource:(StyleElementsTableSource *)tableDataSource didSelectItem:(StyleElementItem *)item;

@end
@interface StyleElementsTableSource : NSObject  <NSTableViewDelegate,NSTableViewDataSource>
@property (nonatomic,weak) id <StyleElementTableDataSourceProtocol> sourceDelegate;
-(NSArray <StyleElementItem *> *)datasource;
-(void)updateDataSource:(NSArray <StyleElementItem *> *)datasource;
-(void)changeValue:(id)value forItemWithKey:(NSString *)key;

@end
