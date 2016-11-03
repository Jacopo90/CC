//
//  SignalDataSource.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 01/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "SignalDataSource.h"

@interface SignalDataSource(){
    NSArray *_signals;
}
@end
@implementation SignalDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)setSignals:(NSArray *)signals{
    self->_signals = signals;
}
- (NSInteger)numberOfItemsInComboBox:(NSComboBox*)aComboBox {
    return self->_signals.count;
}
-(NSString *)objectAtIndex:(NSInteger)index{
    return [[self->_signals objectAtIndex:index] objectForKey:@"name"];
}
- (id)comboBox:(NSComboBox*)aComboBox
objectValueForItemAtIndex:(NSInteger)index {
    return [[self->_signals objectAtIndex:index] objectForKey:@"name"];
    
}
@end
