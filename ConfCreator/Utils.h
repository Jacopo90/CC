//
//  Utils.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Utils : NSObject
+ (NSString*)dictToJsonString:(NSDictionary*)dict;
+ (NSDictionary *)dictionaryFromString:(NSString*)stringDictionary error:(NSError **)error;
+ (NSColor*)colorWithHexColorString:(NSString*)inColorString alpha:(CGFloat)alpha;

+ (NSString*)loadStringFromFilePath:(NSString*)filePath;
+ (void)openFileInWindow:(NSWindow*)window completionHandler:(void (^)(NSString* path))completion;

// styles
+ (NSColor *)randomColor;
@end
