//
//  Junction.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAJunction.h"


@interface MIAJunction (){
    MIAComponent *_sender;
    MIAComponent *_receiver;
    NSString *_signal;
    NSString *_receptor;
}
@end

@implementation MIAJunction

- (instancetype)initWithSender:(MIAComponent *)sender
                        signal:(NSString *)signal
                      receiver:(MIAComponent *)receiver
                      receptor:(NSString *)receptor{
    self = [super init];
    if (self) {
        self->_sender = sender;
        self->_signal = signal;
        self->_receiver = receiver;
        self->_receptor = receptor;
        
    }
    return self;
}

-(NSDictionary *)dataDict{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[self->_sender dataDict] objectForKey:@"uid"] forKey:@"sender"];
    [dict setObject:[[self->_receiver dataDict] objectForKey:@"uid"] forKey:@"receiver"];
    [dict setObject:self->_receptor forKey:@"receptor"];
    [dict setObject:self->_signal forKey:@"signal"];
    return (NSDictionary *)dict;
}
-(NSString *)senderUUID{
    return [self->_sender uuid];
}
-(NSString *)receiverUUID{
    return [self->_receiver uuid];
}
-(void)update:(NSDictionary *)newJson completion:(void (^)(NSDictionary *))compBlock
{
    if ([newJson objectForKey:@"signal"]) {
        self->_signal = [newJson objectForKey:@"signal"];
    }
    if ([newJson objectForKey:@"receptor"]) {
        self->_receptor = [newJson objectForKey:@"receptor"];
    }
    
    compBlock([self dataDict]);
}
@end
