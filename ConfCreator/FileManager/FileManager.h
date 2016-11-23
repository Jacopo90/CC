//
//  FileManager.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 12/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface FileManager : NSObject
+ (void)save:(NSDictionary *)jsonDict inPath:(NSString *)path completion:(void(^)(BOOL success))completion;
+ (void)openFileInWindow:(NSWindow*)window completionHandler:(void (^)(NSString* path))completion;
+ (void)exportDocument:(NSString*)name
                toType:(NSString*)typeUTI
              inWindow:(NSWindow*)window
     completionHandler:(void (^)(NSString* path))completion;
@end
