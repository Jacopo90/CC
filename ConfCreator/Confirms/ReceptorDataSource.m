//
//  ReceptorDataSource.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 01/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ReceptorDataSource.h"
@interface ReceptorDataSource(){
    NSArray *_receptors;
}
@end
@implementation ReceptorDataSource
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)setReceptors:(NSArray *)receptors{
    self->_receptors = receptors;
}
- (NSInteger)numberOfItemsInComboBox:(NSComboBox*)aComboBox {
    return self->_receptors.count;
}
-(NSString *)objectAtIndex:(NSInteger)index{
    return [[self->_receptors objectAtIndex:index] objectForKey:@"name"];
}
- (id)comboBox:(NSComboBox*)aComboBox
objectValueForItemAtIndex:(NSInteger)index {
    return [[self->_receptors objectAtIndex:index] objectForKey:@"name"];
}

@end