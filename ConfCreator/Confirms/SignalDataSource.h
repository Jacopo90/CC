//
//  SignalDataSource.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 01/11/16.
//  Copyright © 2016 private. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface SignalDataSource : NSObject<NSComboBoxDataSource>
-(NSString *)objectAtIndex:(NSInteger)index;
-(void)setSignals:(NSArray *)signals;

@end
