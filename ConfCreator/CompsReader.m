//
//  CompsReader.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 01/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "CompsReader.h"
#import "Utils.h"

@implementation CompsReader
+(NSArray *)loadCompsFromPath:(NSString *)path{
    NSString *jsonString = [Utils loadStringFromFilePath:path];
    
    NSError *error;
    NSDictionary *json = [Utils dictionaryFromString:jsonString error:&error];
    if (error) {
        NSLog(@"error loading comps : %@",error);
        return nil;
    }
    if ([json objectForKey:@"components"]) {
        return [json objectForKey:@"components"];
    }
    return nil;
}
+(NSDictionary *)componentWithName:(NSString *)name inPath:(NSString *)path{

    NSArray *comps = [CompsReader loadCompsFromPath:path];
    if (!comps) {
        return nil;
    }
    for (NSDictionary *comp in comps) {
        if ([[comp objectForKey:@"name"] isEqualToString:name]) {
            return comp;
            break;
        }
    }
    return nil;
}


@end
