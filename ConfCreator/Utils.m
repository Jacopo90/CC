//
//  Utils.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 28/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (NSString*)dictToJsonString:(NSDictionary*)dict {
    NSData* jsonData =
    [NSJSONSerialization dataWithJSONObject:dict
                                    options:NSJSONWritingPrettyPrinted
                                      error:nil];
    return [[NSString alloc] initWithBytes:[jsonData bytes]
                                    length:[jsonData length]
                                  encoding:NSUTF8StringEncoding];
}
+ (NSDictionary *)dictionaryFromString:(NSString*)stringDictionary error:(NSError **)error{
    NSDictionary* JSON;
    if (![stringDictionary isKindOfClass:[NSString class]]) {
        return nil;
    }
   
    JSON = [NSJSONSerialization
                JSONObjectWithData:[stringDictionary
                                    dataUsingEncoding:NSUTF8StringEncoding]
                options:kNilOptions
                error:error];
    
    if (*error) {
        return nil;
    }
    
    return JSON;
    
}
+ (NSColor*)colorWithHexColorString:(NSString*)inColorString alpha:(CGFloat)alpha{
    
    if ([inColorString hasPrefix:@"#"]) {
        inColorString = [inColorString
                         substringWithRange:NSMakeRange(1, [inColorString length] - 1)];
    }
    
    unsigned int colorCode = 0;
    
    if (inColorString) {
        NSScanner* scanner = [NSScanner scannerWithString:inColorString];
        (void)[scanner scanHexInt:&colorCode];
    }
    
    return [NSColor colorWithDeviceRed:((colorCode >> 16) & 0xFF) / 255.0
                                 green:((colorCode >> 8) & 0xFF) / 255.0
                                  blue:((colorCode)&0xFF) / 255.0
                                 alpha:alpha];
}
+ (NSString*)loadStringFromFilePath:(NSString*)filePath {
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSString* jsonString =
        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}
+(NSColor *)randomColor{
    float hue =  arc4random() % 255/255.0f;
    float saturation = arc4random() % 50/100.0f;  //  0.5 to 1.0, away from white
    float brightness = arc4random() % 100/100.0f;  //  0.5 to 1.0, away from black
    return [NSColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
+ (void)openFileInWindow:(NSWindow*)window
          completionHandler:(void (^)(NSString* path))completion {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    openPanel.title = @"Choose a file";
    openPanel.showsResizeIndicator = YES;
    openPanel.showsHiddenFiles = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canCreateDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedFileTypes = @[ @"json" ];
    
    [openPanel
     beginSheetModalForWindow:window
     completionHandler:^(NSInteger result) {
         
         if (result == NSModalResponseOK) {
             
             NSURL* selection = openPanel.URLs[0];
             NSString* path =
             [selection.path stringByResolvingSymlinksInPath];
             completion(path);
         }
         
     }];
}
@end
