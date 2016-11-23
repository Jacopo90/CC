//
//  FileManager.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 12/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "FileManager.h"
#import "Utils.h"

@implementation FileManager
+ (void)save:(NSDictionary *)jsonDict inPath:(NSString *)path completion:(void(^)(BOOL success))completion{
    NSData* json1 =
    [NSJSONSerialization dataWithJSONObject:jsonDict
                                    options:NSJSONWritingPrettyPrinted
                                      error:nil];
    BOOL success = [json1 writeToFile:path atomically:YES];
    completion(success);
}
+ (void)openFileInWindow:(NSWindow*)window completionHandler:(void (^)(NSString* path))completion {
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
+ (void)exportDocument:(NSString*)name
                toType:(NSString*)typeUTI
              inWindow:(NSWindow*)window
     completionHandler:(void (^)(NSString* path))completion {
    
    NSString* newName = [[name stringByDeletingPathExtension]
                         stringByAppendingPathExtension:typeUTI];
    NSSavePanel* panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:newName];
    [panel beginSheetModalForWindow:window
                  completionHandler:^(NSInteger result) {
                      
                      if (result == NSFileHandlingPanelOKButton)
                          
                      {
                          NSURL* theFile = [panel URL];
                          NSString* path =
                          [theFile.path stringByResolvingSymlinksInPath];
                          completion(path);
                          
                          // Write the contents in the new format.
                      }
                      
                  }];
}
@end
