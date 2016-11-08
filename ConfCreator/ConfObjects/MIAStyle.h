//
//  MIAStyle.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAObject.h"
#import "MIAComponent.h"

@interface MIAStyle : MIAObject
- (instancetype)initWithComponent:(MIAComponent *)component uiElements:(NSArray *)elements;
-(NSString *)componentUID;

@end
