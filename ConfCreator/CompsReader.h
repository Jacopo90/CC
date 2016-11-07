//
//  CompsReader.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 01/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompsReader : NSObject
+(NSDictionary *)componentWithName:(NSString *)name inPath:(NSString *)path;
+(NSArray *)loadCompsFromPath:(NSString *)path;

@end
