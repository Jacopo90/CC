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
-(void)tableDataSource:(StyleElementsTableSource *)tableDataSource didSelectItem:(NSDictionary *)item;

@end
@interface StyleElementsTableSource : NSObject  <NSTableViewDelegate,NSTableViewDataSource>
@property (nonatomic,weak) id <StyleElementTableDataSourceProtocol> sourceDelegate;
-(NSArray *)datasource;
-(void)addItemWithKey:(NSString *)key type:(NSString *)type;
-(void)changeValue:(id)value forItemWithKey:(NSString *)key;
-(void)clean;

@end
