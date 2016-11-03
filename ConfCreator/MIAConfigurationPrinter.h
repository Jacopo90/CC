//
//  MIAConfigurationPrinter.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAConfiguration.h"

@interface MIAConfigurationPrinter : NSObject
+(NSDictionary *)printConfiguration:(MIAConfiguration *)configuration adds:(NSDictionary *)adds;
@end
