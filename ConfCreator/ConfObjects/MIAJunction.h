//
//  Junction.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIAComponent.h"

@interface MIAJunction : MIAObject
-(NSString *)senderUUID;
-(NSString *)receiverUUID;
- (instancetype)initWithSender:(MIAComponent *)sender
                        signal:(NSString *)signal
                      receiver:(MIAComponent *)receiver
                      receptor:(NSString *)receptor;
@end
