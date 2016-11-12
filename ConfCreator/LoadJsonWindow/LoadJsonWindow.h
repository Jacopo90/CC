//
//  LoadJsonWindow.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 12/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LoadJsonWindow;

@protocol LoadJsonWindowProtocol <NSObject>
-(void)loadJsonWindow:(LoadJsonWindow *)loadJsonWindow confirmJson:(NSDictionary *)jsonDict;

@end
@interface LoadJsonWindow : NSWindowController
@property (nonatomic,weak) id <LoadJsonWindowProtocol> delegate;

@end
