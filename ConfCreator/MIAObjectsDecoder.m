//
//  MIAObjectsDecoder.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAObjectsDecoder.h"
#import "CompsReader.h"


@implementation MIAObjectsDecoder
+(NSArray <MIAComponent *>*)componentsFromJson:(NSDictionary *)jsonDict{
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    
    NSArray *comps = [jsonDict objectForKey:@"components"];

    if (comps && [comps isKindOfClass:[NSArray class]]) {
      
            [self cycleObjects:^(NSDictionary *dict) {
                NSString *name = [dict objectForKey:@"name"];
                NSString *uid = [dict objectForKey:@"uid"];
                NSDictionary *args = [dict objectForKey:@"args"];
                NSString *targetUID = [dict objectForKey:@"target_uid"];
                if (name && uid) {
                    MIAComponent *component = [[MIAComponent alloc]initWithName:name uid:uid];
                    [component updateArgs:args];
                    [component updateTargetUID:targetUID];
                    component.definition = [MIAObjectsDecoder definitionFromName:name];
                    [objects addObject:component];
                }

            } inArray:comps];
    }
    return objects;
}
+(NSDictionary *)definitionFromName:(NSString *)name{
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/comps_def.json",desktopPath];;
    NSDictionary *def = [CompsReader componentWithName:name inPath:path];
    return def;
}

+(NSArray <MIAJunction *>*)junctionsFromJson:(NSDictionary *)jsonDict withComponents:(NSArray<MIAComponent *>*)components {
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    
    NSArray *juncs = [jsonDict objectForKey:@"junctions"];
    
    if (juncs && [juncs isKindOfClass:[NSArray class]]) {
        [self cycleObjects:^(NSDictionary *dict) {
            NSString *senderID =  [dict objectForKey:@"sender"];
            NSString *receiverID =  [dict objectForKey:@"receiver"];
            MIAComponent *sender = nil;
            MIAComponent *receiver = nil;
            
            for (MIAComponent *comp in components) {
                if ([[[comp dataDict] objectForKey:@"uid"] isEqualToString:senderID]) {
                    sender = comp;
                }
                if ([[[comp dataDict] objectForKey:@"uid"] isEqualToString:receiverID]) {
                    receiver = comp;
                }
            }
            NSString *signal = [dict objectForKey:@"signal"];
            NSString *receptor = [dict objectForKey:@"receptor"];
            
            if (signal && sender && receiver && receptor) {
                MIAJunction *junction = [[MIAJunction alloc]initWithSender:sender
                                                                    signal:signal
                                                                  receiver:receiver
                                                                  receptor:receptor];
                [objects addObject:junction];
            }
            
        } inArray:juncs];
    }
    return objects;
}
+(NSArray <MIAStyle *> *)stylesFromJson:(NSDictionary *)jsonDict withComponents:(NSArray <MIAComponent *> *)components{
    NSMutableArray *objects = [[NSMutableArray alloc]init];
    if ([[jsonDict objectForKey:@"styles"] count] == 0) {
        return nil;
    }
    NSDictionary *item = [[jsonDict objectForKey:@"styles"] objectAtIndex:0];
    
    if (item == nil){
        return nil;
    }
    NSString *name = [item objectForKey:@"name"]; // maybe a day will be usefull
    NSArray *items = [item objectForKey:@"items"];
    
    [self cycleObjects:^(NSDictionary *dict) {
        NSString *uid = [dict objectForKey:@"id"];
        NSMutableArray *uiValues = [[NSMutableArray alloc]init];
        NSDictionary *rules = [dict objectForKey:@"rules"];
        
        for (NSString *key in rules) {
            NSMutableDictionary *uielem = [[NSMutableDictionary alloc]init];
            [uielem setObject:key forKey:@"key"];
            [uielem setObject:@"view" forKey:@"type"];
            [uielem setObject:[rules objectForKey:key] forKey:@"values"];
            [uiValues addObject:uielem];
        }
        for (MIAComponent *comp in components) {
            if ([[[comp dataDict] objectForKey:@"uid"] isEqualToString:uid]) {
                MIAStyle *style = [[MIAStyle alloc]initWithComponent:comp uiElements:uiValues];
                [objects addObject:style];
            }

        }
        // every object of array must be set in this way : key , type and values
    } inArray:items];
    
    return objects;
}
+(void)cycleObjects:(void(^)(NSDictionary *dict))cycle inArray:(NSArray *)array{
    for (id obj in array) {
        cycle(obj);
    }
}
@end
